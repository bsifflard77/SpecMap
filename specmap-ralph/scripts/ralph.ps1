<#
.SYNOPSIS
    Ralph - Autonomous coding loop for SpecMap PRD execution

.DESCRIPTION
    Executes PRD stories one criterion at a time using Claude Code.
    Each iteration gets fresh context, reads progress.md for state,
    completes ONE criterion, updates both PRD.md and progress.md.

.PARAMETER MaxIterationsPerStory
    Maximum attempts per story before stopping (default: 5)

.PARAMETER MaxTotalIterations
    Absolute cap on total iterations (default: 50)

.PARAMETER SleepSeconds
    Pause between iterations (default: 2)

.PARAMETER UntilComplete
    Override: run without iteration caps

.PARAMETER Resume
    Continue from progress.md state (pulls first)

.PARAMETER Skip
    Skip a specific story: -Skip "US-003"

.PARAMETER DryRun
    Show prompt without executing

.PARAMETER PRDPath
    Path to PRD.md (default: ./PRD.md)

.PARAMETER ProgressPath
    Path to progress.md (default: ./progress.md)

.EXAMPLE
    .\ralph.ps1
    Run with default settings

.EXAMPLE
    .\ralph.ps1 -Resume
    Continue from where we left off

.EXAMPLE
    .\ralph.ps1 -Skip "US-003" -MaxIterationsPerStory 8
    Skip US-003 and increase retry limit
#>

param(
    [int]$MaxIterationsPerStory = 5,
    [int]$MaxTotalIterations = 50,
    [int]$SleepSeconds = 2,
    [switch]$UntilComplete = $false,
    [switch]$Resume = $false,
    [string]$Skip = "",
    [switch]$DryRun = $false,
    [string]$PRDPath = "./PRD.md",
    [string]$ProgressPath = "./progress.md"
)

# ============================================================================
# CONFIGURATION
# ============================================================================

$script:IterationPrompt = @"
You are Ralph, an autonomous coding agent. Complete ONE criterion per iteration.

## Session Start (Read First)

1. Read progress.md - Check:
   - Cold Start Briefing (WHERE to continue)
   - Learnings section (patterns to apply)

2. Read PRD.md - Find the criterion mentioned in Cold Start Briefing

3. Verify state matches:
   - Is the story correct?
   - Is the criterion still [ ]?
   - Any blockers noted?

## Work Protocol

4. Implement the ONE criterion from Cold Start Briefing
   - Focus on THIS criterion only
   - Apply learnings from progress.md
   - Keep changes minimal

5. Verify:
   - Run typecheck (must pass)
   - Run tests (must pass)
   - Browser check (if UI criterion)

## Completion Protocol

6. If ALL verifications PASS:
   - Update PRD.md: Mark criterion [x]
   - Update PRD.md: If all story criteria [x], mark story complete
   - Git commit: "feat: [brief description]"
   - Update progress.md:
     - Add iteration log entry with timestamp
     - Update Cold Start Briefing to NEXT criterion
     - Add any learnings discovered
     - Update Story Summary table

7. If ANY verification FAILS:
   - Do NOT mark criterion [x]
   - Do NOT commit
   - Update progress.md:
     - Add iteration log entry (status: failed)
     - Update Cold Start Briefing with failure details
     - Add learnings (what went wrong)

## End Signal

After updating progress.md, check PRD.md:
- If ALL stories complete: Output <promise>COMPLETE</promise>
- If stories remain with [ ]: End response (next iteration continues)

## Critical Rules

- ONE criterion per iteration
- ALWAYS update progress.md (even on failure)
- Learnings section is your memory between iterations
- Cold Start Briefing must reflect current state
- Include timestamp on all updates: [YYYY-MM-DD HH:MM:SS]
"@

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

$script:exitPushRegistered = $false
$script:storyAttempts = @{}

function Write-Banner {
    param([string]$Text, [string]$Color = "Cyan")

    $line = "=" * 60
    Write-Host ""
    Write-Host $line -ForegroundColor $Color
    Write-Host "  $Text" -ForegroundColor $Color
    Write-Host $line -ForegroundColor $Color
    Write-Host ""
}

function Write-Status {
    param([string]$Text, [string]$Color = "White")
    Write-Host "  $Text" -ForegroundColor $Color
}

function Register-ExitPush {
    if (-not $script:exitPushRegistered) {
        $script:exitPushRegistered = $true
    }
}

function Push-ToRemote {
    param([string]$Reason = "checkpoint")

    $result = git push origin HEAD 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Status "Pushed to remote ($Reason)" "Green"
        Update-ProgressLastPush $Reason
        return $true
    } else {
        Write-Warning "  Push failed ($Reason) - continue locally"
        Update-ProgressPushStatus "Pending"
        return $false
    }
}

function Pull-BeforeResume {
    Write-Status "Checking for remote changes..." "Yellow"

    $fetchResult = git fetch origin 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "  Could not fetch from remote"
        return
    }

    $behind = git rev-list HEAD..origin/HEAD --count 2>&1
    if ($LASTEXITCODE -eq 0 -and [int]$behind -gt 0) {
        Write-Status "Remote has $behind new commits. Pulling..." "Yellow"
        git pull --rebase origin HEAD
    } else {
        Write-Status "Up to date with remote" "Green"
    }
}

function Get-CurrentStoryFromProgress {
    if (-not (Test-Path $ProgressPath)) {
        return $null
    }

    $content = Get-Content $ProgressPath -Raw
    if ($content -match '\*\*Story\*\*:\s*(US-\d+)') {
        return $matches[1]
    }
    return $null
}

function Get-StoryAttempts {
    param([string]$StoryId)

    if ($script:storyAttempts.ContainsKey($StoryId)) {
        return $script:storyAttempts[$StoryId]
    }
    return 0
}

function Increment-StoryAttempts {
    param([string]$StoryId)

    if (-not $script:storyAttempts.ContainsKey($StoryId)) {
        $script:storyAttempts[$StoryId] = 0
    }
    $script:storyAttempts[$StoryId]++
}

function Update-ProgressLastPush {
    param([string]$Reason)

    if (-not (Test-Path $ProgressPath)) { return }

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $content = Get-Content $ProgressPath -Raw

    if ($content -match '\*\*Last Push\*\*:.*') {
        $content = $content -replace '\*\*Last Push\*\*:.*', "**Last Push**: $timestamp ($Reason)"
    }

    Set-Content $ProgressPath $content -NoNewline
}

function Update-ProgressPushStatus {
    param([string]$Status)

    if (-not (Test-Path $ProgressPath)) { return }

    $content = Get-Content $ProgressPath -Raw

    if ($content -match '\*\*Push Status\*\*:.*') {
        $content = $content -replace '\*\*Push Status\*\*:.*', "**Push Status**: $Status"
    }

    Set-Content $ProgressPath $content -NoNewline
}

function Is-StuckOnSameError {
    param([string]$Result, [int]$Threshold = 3)
    return $false
}

function Invoke-ClaudeIteration {
    param([string]$Prompt)

    $result = claude -p $Prompt 2>&1
    return $result
}

function Show-CompletionSummary {
    Write-Banner "ALL STORIES COMPLETE" "Green"

    if (Test-Path $ProgressPath) {
        $content = Get-Content $ProgressPath -Raw

        if ($content -match '## Story Summary([\s\S]*?)(?=##|$)') {
            Write-Host $matches[1]
        }
    }

    Write-Host ""
    Write-Status "Next Steps:" "Cyan"
    Write-Status "  1. Review commits: git log --oneline -10"
    Write-Status "  2. Test in browser: npm run dev"
    Write-Status "  3. Merge to main: git checkout main && git merge <branch>"
    Write-Host ""
}

function Show-StuckReport {
    param([string]$StoryId)

    Write-Banner "STOPPED - Story $StoryId failed $MaxIterationsPerStory times" "Yellow"

    if (Test-Path $ProgressPath) {
        $content = Get-Content $ProgressPath -Raw

        if ($content -match '## Cold Start Briefing([\s\S]*?)---') {
            Write-Host "Current State:"
            Write-Host $matches[1]
        }

        if ($content -match '## Learnings([\s\S]*?)---') {
            Write-Host "Recent Learnings:"
            Write-Host $matches[1]
        }
    }

    Write-Host ""
    Write-Status "Options:" "Cyan"
    Write-Status "  1. Fix manually, then resume:"
    Write-Status "       .\ralph.ps1 -Resume"
    Write-Status ""
    Write-Status "  2. Skip this story, continue others:"
    Write-Status "       .\ralph.ps1 -Skip `"$StoryId`""
    Write-Status ""
    Write-Status "  3. Increase retry limit:"
    Write-Status "       .\ralph.ps1 -MaxIterationsPerStory 8"
    Write-Host ""
}

function Show-ProgressSummary {
    Write-Banner "PROGRESS SUMMARY" "Cyan"

    if (Test-Path $ProgressPath) {
        $content = Get-Content $ProgressPath -Raw

        if ($content -match '## Story Summary([\s\S]*?)(?=##|$)') {
            Write-Host $matches[1]
        }
    }
}

function Test-PRDComplete {
    if (-not (Test-Path $PRDPath)) { return $false }

    $content = Get-Content $PRDPath -Raw

    if ($content -match '\[ \]') {
        return $false
    }

    return $true
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

try {
    # Validate files exist
    if (-not (Test-Path $PRDPath)) {
        Write-Banner "PRD.md not found" "Red"
        Write-Status "To create a PRD:"
        Write-Status "  /prd [feature description]"
        Write-Status ""
        Write-Status "Or specify a path:"
        Write-Status "  .\ralph.ps1 -PRDPath `"./specs/PRD.md`""
        exit 4
    }

    if (-not (Test-Path $ProgressPath)) {
        Write-Banner "progress.md not found - creating from PRD" "Yellow"
        Write-Status "Please create progress.md first using /prd command"
        exit 5
    }

    Register-ExitPush

    if ($Resume) {
        Pull-BeforeResume
    }

    $limitText = if ($UntilComplete) { "no limits" } else { "Max $MaxIterationsPerStory per story, $MaxTotalIterations total" }
    Write-Banner "Starting Ralph - $limitText"

    if ($DryRun) {
        Write-Status "DRY RUN MODE - Showing prompt only" "Yellow"
        Write-Host ""
        Write-Host $script:IterationPrompt
        exit 0
    }

    $previousStory = $null

    for ($i = 1; $i -le $MaxTotalIterations; $i++) {

        Write-Banner "Iteration $i of $MaxTotalIterations"

        $currentStory = Get-CurrentStoryFromProgress

        if (-not $currentStory) {
            Write-Status "Could not determine current story from progress.md" "Red"
            exit 5
        }

        if ($Skip -and $currentStory -eq $Skip) {
            Write-Status "Skipping $currentStory as requested" "Yellow"
            continue
        }

        $attempts = Get-StoryAttempts $currentStory

        if ($attempts -ge $MaxIterationsPerStory -and -not $UntilComplete) {
            Write-Warning "Story $currentStory failed $MaxIterationsPerStory times. Stopping."
            Show-StuckReport $currentStory
            Push-ToRemote -Reason "stuck on $currentStory"
            exit 2
        }

        Increment-StoryAttempts $currentStory

        Write-Status "Story: $currentStory (attempt $(Get-StoryAttempts $currentStory))" "Cyan"

        $result = Invoke-ClaudeIteration $script:IterationPrompt

        $newStory = Get-CurrentStoryFromProgress
        if ($previousStory -and $newStory -ne $previousStory) {
            Write-Status "Story $previousStory complete!" "Green"
            Push-ToRemote -Reason "$previousStory complete"
            $script:storyAttempts[$newStory] = 0
        }
        $previousStory = $newStory

        if ($result -match "<promise>COMPLETE</promise>") {
            Push-ToRemote -Reason "all stories complete"
            Show-CompletionSummary
            exit 0
        }

        if (Test-PRDComplete) {
            Push-ToRemote -Reason "all stories complete"
            Show-CompletionSummary
            exit 0
        }

        if (Is-StuckOnSameError $result 3) {
            Write-Warning "Same error 3 consecutive times. Stopping."
            Show-StuckReport $currentStory
            Push-ToRemote -Reason "stuck - same error 3x"
            exit 3
        }

        Start-Sleep -Seconds $SleepSeconds
    }

    Write-Warning "Reached max iterations ($MaxTotalIterations). Stopping."
    Push-ToRemote -Reason "max iterations reached"
    Show-ProgressSummary
    exit 1

} finally {
    if (-not $DryRun) {
        Push-ToRemote -Reason "session exit"
    }
}
