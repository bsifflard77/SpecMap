#!/usr/bin/env pwsh
<#
.SYNOPSIS
    SpecMap 3.0 Setup Script - Initialize or integrate SpecMap into any project

.DESCRIPTION
    This script can:
    1. Initialize a new project with SpecMap from scratch
    2. Integrate SpecMap into an existing project

    SpecMap treats AI like a crash-prone process with no memory guarantees.
    That's why we use save files, cold start briefings, and integrity checks.

.PARAMETER ProjectPath
    Path to the project directory. Defaults to current directory.

.PARAMETER ProjectName
    Name of the project (required for new projects)

.PARAMETER Mode
    'new' for new projects, 'integrate' for existing projects

.PARAMETER ProjectType
    Type of project: web-app, mobile-app, api, library, cli

.EXAMPLE
    # New project
    .\specmap-setup.ps1 -Mode new -ProjectName "my-app" -ProjectPath "C:\Projects"

.EXAMPLE
    # Integrate into existing project
    .\specmap-setup.ps1 -Mode integrate -ProjectPath "C:\Projects\existing-app"

.NOTES
    Version: 3.0.0
    SpecMap - Specification-driven development with AI
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$ProjectPath = ".",

    [Parameter(Mandatory=$false)]
    [string]$ProjectName = "",

    [Parameter(Mandatory=$true)]
    [ValidateSet("new", "integrate")]
    [string]$Mode,

    [Parameter(Mandatory=$false)]
    [ValidateSet("web-app", "mobile-app", "api", "library", "cli")]
    [string]$ProjectType = "web-app"
)

# ============================================================================
# CONFIGURATION
# ============================================================================

$SpecMapVersion = "3.3.2"
$Date = Get-Date -Format "yyyy-MM-dd"
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"

# ============================================================================
# TEMPLATES
# ============================================================================

$ClaudeMdTemplate = @"
# SpecMap Project Instructions

This project uses SpecMap for specification-driven development with the RULEMAP framework.

## Core Files

- ``SPECMAP.md`` - Project rules and conventions
- ``features.json`` - Feature registry with counters
- ``progress.md`` - Session heartbeat (update after EVERY action)

## Workflow

``````
specify -> clarify -> plan -> tasks -> implement -> track
``````

## RULEMAP Framework

All specifications must score >= 8.0 across these elements:

| Element | Focus |
|---------|-------|
| **R** - Role | Authority & responsibility |
| **U** - Understanding | Objectives & success criteria |
| **L** - Logic | Structure & flow |
| **E** - Elements | Specifications & constraints |
| **M** - Mood | Experience & aesthetics |
| **A** - Audience | Stakeholders & users |
| **P** - Performance | Metrics & success criteria |

## Tracking IDs

Format: ``[FEATURE]-[TYPE]-[NUMBER]``

| Code | Type | Example |
|------|------|---------|
| F | Feature | 001-F |
| R | Requirement | 001-R-015 |
| T | Task | 001-T-042 |
| Q | Question | 001-Q-007 |
| D | Decision | 001-D-003 |
| I | Issue | 001-I-001 |
| A | Acceptance | 001-A-012 |
| M | Milestone | 001-M-002 |

## Commands

Use these slash commands for SpecMap workflows:

- ``/specify [concept]`` - Create RULEMAP specification
- ``/clarify [feature-id]`` - Resolve ambiguities
- ``/plan [feature-id]`` - Generate implementation plan
- ``/tasks [feature-id]`` - Break down into TDD tasks
- ``/track`` - Update progress tracking

## Quality Gates

| Phase | Criteria |
|-------|----------|
| Specification | RULEMAP >= 8.0, no [NEEDS CLARIFICATION] |
| Planning | All decisions made, milestones defined |
| Tasks | All requirements mapped, dependencies clear |
| Implementation | Tests passing, acceptance criteria met |

## Progress Updates

After EVERY action, update progress.md:

``````markdown
### [DATE]

#### Completed
- [ID]: [Description]

#### In Progress
- [ID]: [Description]

#### Blocked
- [ID]: Waiting on [dependency]
``````
"@

$SpecifyCommandTemplate = @"
---
description: Create a RULEMAP specification for a feature
---

# /specify

Create a comprehensive specification using the RULEMAP framework.

## Usage
``/specify [feature-name-or-concept]``

## Process

1. **Analyze** the feature concept
2. **Generate** RULEMAP specification with scores
3. **Identify** any ambiguities with [NEEDS CLARIFICATION]
4. **Create** feature folder and spec.md
5. **Register** in features.json
6. **Update** progress.md

## RULEMAP Template

Score each element 1-10:

| Element | Score | Notes |
|---------|-------|-------|
| R - Role | ?/10 | Who owns this? |
| U - Understanding | ?/10 | Clear objectives? |
| L - Logic | ?/10 | Flow defined? |
| E - Elements | ?/10 | All specs covered? |
| M - Mood | ?/10 | UX considered? |
| A - Audience | ?/10 | Users identified? |
| P - Performance | ?/10 | Metrics set? |
| **Total** | ?/70 | **Average: ?/10** |

## Quality Gate
- Minimum average score: 8.0/10
- No [NEEDS CLARIFICATION] markers
"@

$ClarifyCommandTemplate = @"
---
description: Resolve ambiguities in a specification
---

# /clarify

Identify and resolve ambiguities in an existing specification.

## Usage
``/clarify [feature-id]``

## Process

1. **Read** the feature's spec.md
2. **Identify** all [NEEDS CLARIFICATION] markers
3. **Ask** targeted questions for each
4. **Update** spec.md with answers
5. **Re-score** RULEMAP elements
6. **Update** progress.md

## Question Categories

- **Scope**: What's in/out?
- **Behavior**: What happens when...?
- **Edge Cases**: What if...?
- **Integration**: How does this connect to...?
- **Constraints**: What are the limits?
"@

$PlanCommandTemplate = @"
---
description: Generate implementation plan for a feature
---

# /plan

Create a detailed implementation plan for a clarified specification.

## Usage
``/plan [feature-id]``

## Prerequisites
- Specification must have RULEMAP >= 8.0
- No [NEEDS CLARIFICATION] markers

## Process

1. **Verify** spec is ready (quality gate)
2. **Analyze** technical requirements
3. **Define** milestones
4. **Identify** dependencies
5. **Create** plan.md in feature folder
6. **Update** features.json with milestones
7. **Update** progress.md

## Plan Structure

- Milestones with clear deliverables
- Dependencies between components
- Technical decisions with rationale
- Risk considerations
"@

$TasksCommandTemplate = @"
---
description: Break down plan into TDD tasks
---

# /tasks

Convert implementation plan into actionable TDD tasks.

## Usage
``/tasks [feature-id]``

## Prerequisites
- Plan must be complete
- All milestones defined

## Process

1. **Read** plan.md
2. **Break down** each milestone into tasks
3. **Define** test-first approach for each
4. **Set** dependencies
5. **Create** tasks.md in feature folder
6. **Update** features.json with tasks
7. **Update** progress.md

## Task Format

Each task includes:
- ID: [FEATURE]-T-[NUM]
- Description
- Test criteria (TDD)
- Dependencies
- Acceptance criteria link
"@

$TrackCommandTemplate = @"
---
description: Update progress tracking
---

# /track

Update the progress.md file with current session status.

## Usage
``/track``

## Process

1. **Review** current session work
2. **Update** completed items
3. **Log** in-progress items
4. **Note** blockers
5. **Update** timestamps

## Update Format

``````markdown
### [DATE]

#### Completed
- [ID]: [Description]

#### In Progress
- [ID]: [Description]

#### Blocked
- [ID]: Waiting on [dependency]
``````
"@

function Get-SpecMapMd {
    param([string]$Name, [string]$Type, [string]$Description)

    return @"
# $Name

## The Mental Model

> **SpecMap treats AI like a crash-prone process with no memory guarantees.**
>
> That's why we use save files, cold start briefings, and integrity checks.

---

## What SpecMap Is NOT

- **Not a task manager** -> Use Jira/Linear for that
- **Not a workflow engine** -> Use n8n/Temporal for that
- **Not an agent framework** -> Use LangGraph/CrewAI for that
- **Not a memory database** -> Use vector DBs for that

**SpecMap is a state persistence layer.** It interfaces with all of the above.

---

## CRITICAL RULES - READ THIS FIRST

### The One Rule That Cannot Break

> **If progress.md isn't updated, SpecMap is broken.**
>
> Everything else can be imperfect. This cannot.

### The Save File Philosophy

> progress.md is a SAVE FILE, not a log. A brand new agent with zero
> prior context should be able to read it and continue immediately.

### Priority Under Pressure

> **If forced to choose, preserve snapshot over history.**
> **When in doubt, delete history before touching snapshot sections.**

---

## Before ANY Work

1. Read progress.md completely
2. Check **Last Known Good State** (first paragraph)
3. Run **Snapshot Integrity Check**
4. Check **Resume Confidence** - if < 3, clarify with user first
5. Read the **Cold Start Briefing** in Active Task section
6. Check **Decisions table** for prior choices
7. Continue from where it left off
8. Do NOT repeat completed work

## After EVERY Completed Action

1. Add entry to Session Log with timestamp
2. Add 2-4 bullet points of specifics
3. Update Feature Status table if needed
4. Update **Active Task** including Cold Start Briefing
5. Update **Last Known Good State** (top of file)
6. Update **Resume Confidence**
7. Update **Context Budget** if significantly changed
8. Save progress.md IMMEDIATELY

---

## Critical Operations (Require Human Approval)

**STOP and ask before executing any of these:**

- [ ] Deleting files or data
- [ ] Database migrations or schema changes
- [ ] External API calls with production credentials
- [ ] Git operations on main/master/production branches
- [ ] Any action that costs money (paid API calls, deployments)
- [ ] Security-sensitive changes (auth, permissions, encryption)
- [ ] Installing new dependencies that affect security

**Protocol:** State what you're about to do, why, and wait for "proceed".

---

## Compaction Recovery Protocol

If you notice loss of context, confusion, or uncertainty:

1. **STOP** - Do not guess or continue blindly
2. **READ** progress.md from the top (Last Known Good State)
3. **RUN** Snapshot Integrity Check
4. **READ** the Cold Start Briefing in Active Task
5. **CHECK** the Decisions table for prior choices
6. **UPDATE** Resume Confidence (probably 2/5 or lower)
7. **ASK** if confidence < 3

---

## Project Overview

**Type:** $Type
**Created:** $Date

$Description

---

## Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | [TBD] |
| Database | [TBD] |
| Libraries | [TBD] |

---

## Commands

``````bash
dev:   [TBD]
test:  [TBD]
build: [TBD]
lint:  [TBD]
``````

---

## Security Checklist

### Before Every Commit
- [ ] No hardcoded secrets
- [ ] No .env files being committed
- [ ] Linter passes

### Before Feature Complete
- [ ] All tasks completed
- [ ] Acceptance criteria passing
- [ ] Security check passed
- [ ] Tests passing
"@
}

function Get-FeaturesJson {
    param([string]$Name, [string]$Type)

    return @{
        project = @{
            name = $Name
            type = $Type
            created = $Date
            version = "1.0.0"
        }
        features = @()
        counters = @{
            feature = 0
            requirement = 0
            task = 0
            question = 0
            decision = 0
            issue = 0
            acceptance = 0
            milestone = 0
        }
    } | ConvertTo-Json -Depth 10
}

function Get-ProgressMd {
    param([string]$Name)

    return @"
# Progress: $Name

> **Last Known Good State ($Timestamp):**
> Project initialized with SpecMap $SpecMapVersion. No features defined yet.
> Ready to begin. No blockers. No decisions yet. Resume confidence: 5/5.

**Project:** $Name
**Last Updated:** $Timestamp
**Session:** #1

---

## SNAPSHOT SECTIONS (Sacred - Preserve First)

---

## Resume Confidence

| Check | Value |
|-------|-------|
| **Confidence** | 5/5 |
| **Missing Info** | None |
| **Last Verified** | $Timestamp |

> If confidence < 3, clarify with user before proceeding.

---

## Snapshot Integrity Check

Before proceeding, verify:
- [ ] Last Known Good State reflects current reality
- [ ] Active Task matches Feature Status table
- [ ] Cold Start Briefing is accurate and complete
- [ ] Resume Confidence is set honestly
- [ ] Decisions table includes recent choices

> If any box is unchecked, fix it before doing new work.

---

## Context Budget (Estimated)

| File | Est. Tokens | Status |
|------|-------------|--------|
| SPECMAP.md | ~550 | Lean |
| features.json | ~200 | Lean |
| progress.md | ~500 | Lean |
| **Total Core** | **~1,250** | Under 2,000 |

> **Rule:** If Total Core exceeds 2,000 tokens, archive completed work immediately.

---

## Active Task

| Field | Value |
|-------|-------|
| **Task** | Initialize first feature |
| **ID** | TBD |
| **Feature** | TBD |
| **Started** | $Timestamp |

### Cold Start Briefing

**What:** Project just initialized. Waiting for first feature to be specified.

**Why:** No features defined yet. User should run ``/specify [feature-name]`` to create first specification.

**Where:** TBD based on feature

**Current State:** SpecMap files created. Ready for first feature.

**Next Step:** Ask user what feature to build first, or wait for ``/specify`` command.

**Blockers:** None.

---

## Feature Status

| ID | Feature | Status | Progress | Blockers |
|----|---------|--------|----------|----------|
| - | (none yet) | - | - | - |

**Legend:** Complete | Active | Pending | Blocked

---

## Decisions

> **Trigger:** Any time you say "we decided..." -> log it here with explicit rationale.

| ID | Decision | Rationale | Date |
|----|----------|-----------|------|
| D-001 | Using SpecMap $SpecMapVersion | Standard project management framework | $Date |

---

## HISTORY SECTIONS (Archive First When Needed)

---

## Session Log

### $Date

#### Session 1 (Started: $Timestamp)

**$Timestamp** - Initialized project with SpecMap $SpecMapVersion
   - Created SPECMAP.md with project rules
   - Created features.json with empty registry
   - Created progress.md with cold start briefing
   - Set up .claude/ folder with commands
   - Ready for first feature specification

---

## Backlog

| Added | Item | Priority | Notes |
|-------|------|----------|-------|
| | (none yet) | | |

---

## Questions

| ID | Question | Blocking | Status |
|----|----------|----------|--------|
| | (none yet) | | |

---

## Blockers

| ID | Blocker | Impact | Status |
|----|---------|--------|--------|
| | (none) | | |

---

## Resume Instructions

``````
THE MENTAL MODEL:
SpecMap treats AI like a crash-prone process with no memory guarantees.

FOR ANY AGENT (including after context compaction):

1. READ the "Last Known Good State" at the top of this file
2. RUN Snapshot Integrity Check - fix any issues before proceeding
3. CHECK Resume Confidence - if < 3, ask user for clarification
4. READ the Cold Start Briefing in the Active Task section
5. CHECK the Decisions table for prior choices
6. SCAN Session Log for recent entries (don't repeat these)
7. CONTINUE from where the Cold Start Briefing indicates

AFTER EVERY COMPLETED ACTION:
1. Add timestamped entry for what you completed
2. Add 2-4 bullet points with specifics
3. Update the Cold Start Briefing for the next action
4. Update Last Known Good State
5. Update Resume Confidence
6. Save IMMEDIATELY
``````
"@
}

# ============================================================================
# MAIN FUNCTIONS
# ============================================================================

function New-SpecMapProject {
    param(
        [string]$Path,
        [string]$Name,
        [string]$Type
    )

    $FullPath = Join-Path $Path $Name

    if (Test-Path $FullPath) {
        Write-Host "Error: Directory already exists: $FullPath" -ForegroundColor Red
        return $false
    }

    Write-Host "`nCreating new SpecMap project: $Name" -ForegroundColor Cyan
    Write-Host "Location: $FullPath" -ForegroundColor Gray
    Write-Host ""

    # Create directories
    New-Item -ItemType Directory -Path $FullPath -Force | Out-Null
    New-Item -ItemType Directory -Path "$FullPath/.claude/commands" -Force | Out-Null
    New-Item -ItemType Directory -Path "$FullPath/01-specifications" -Force | Out-Null

    Write-Host "  Created directory structure" -ForegroundColor Green

    # Create core files
    Set-Content -Path "$FullPath/.claude/CLAUDE.md" -Value $ClaudeMdTemplate
    Set-Content -Path "$FullPath/.claude/commands/specify.md" -Value $SpecifyCommandTemplate
    Set-Content -Path "$FullPath/.claude/commands/clarify.md" -Value $ClarifyCommandTemplate
    Set-Content -Path "$FullPath/.claude/commands/plan.md" -Value $PlanCommandTemplate
    Set-Content -Path "$FullPath/.claude/commands/tasks.md" -Value $TasksCommandTemplate
    Set-Content -Path "$FullPath/.claude/commands/track.md" -Value $TrackCommandTemplate

    Write-Host "  Created .claude/ folder with commands" -ForegroundColor Green

    $SpecMapContent = Get-SpecMapMd -Name $Name -Type $Type -Description "[Project description - update this]"
    Set-Content -Path "$FullPath/SPECMAP.md" -Value $SpecMapContent
    Write-Host "  Created SPECMAP.md" -ForegroundColor Green

    $FeaturesContent = Get-FeaturesJson -Name $Name -Type $Type
    Set-Content -Path "$FullPath/features.json" -Value $FeaturesContent
    Write-Host "  Created features.json" -ForegroundColor Green

    $ProgressContent = Get-ProgressMd -Name $Name
    Set-Content -Path "$FullPath/progress.md" -Value $ProgressContent
    Write-Host "  Created progress.md" -ForegroundColor Green

    # Create .gitignore
    $GitIgnore = @"
# Environment
.env
.env.local
.env.*.local

# Dependencies
node_modules/
__pycache__/
venv/

# Build
dist/
build/
.next/

# IDE
.vscode/
.idea/

# OS
.DS_Store

# Logs
*.log

# SpecMap archives
features.archive.json
"@
    Set-Content -Path "$FullPath/.gitignore" -Value $GitIgnore
    Write-Host "  Created .gitignore" -ForegroundColor Green

    Write-Host ""
    Write-Host "SpecMap $SpecMapVersion project created successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. cd $FullPath"
    Write-Host "  2. Update SPECMAP.md with your project description"
    Write-Host "  3. Run /specify [feature-name] to create your first feature"

    return $true
}

function Add-SpecMapToExisting {
    param(
        [string]$Path
    )

    $FullPath = Resolve-Path $Path -ErrorAction SilentlyContinue

    if (-not $FullPath) {
        Write-Host "Error: Directory does not exist: $Path" -ForegroundColor Red
        return $false
    }

    # Try to detect project name
    $DetectedName = Split-Path $FullPath -Leaf

    # Check for package.json or other config files to get project name
    $PackageJson = Join-Path $FullPath "package.json"
    if (Test-Path $PackageJson) {
        $Package = Get-Content $PackageJson | ConvertFrom-Json
        if ($Package.name) {
            $DetectedName = $Package.name
        }
    }

    Write-Host "`nIntegrating SpecMap into existing project: $DetectedName" -ForegroundColor Cyan
    Write-Host "Location: $FullPath" -ForegroundColor Gray
    Write-Host ""

    # Check for existing SpecMap files
    $HasSpecMap = Test-Path "$FullPath/SPECMAP.md"
    $HasFeatures = Test-Path "$FullPath/features.json"
    $HasProgress = Test-Path "$FullPath/progress.md"
    $HasClaude = Test-Path "$FullPath/.claude"

    if ($HasSpecMap -or $HasFeatures -or $HasProgress) {
        Write-Host "Warning: Some SpecMap files already exist:" -ForegroundColor Yellow
        if ($HasSpecMap) { Write-Host "  - SPECMAP.md" -ForegroundColor Yellow }
        if ($HasFeatures) { Write-Host "  - features.json" -ForegroundColor Yellow }
        if ($HasProgress) { Write-Host "  - progress.md" -ForegroundColor Yellow }
        Write-Host ""

        $Confirm = Read-Host "Overwrite existing files? (y/N)"
        if ($Confirm -ne "y" -and $Confirm -ne "Y") {
            Write-Host "Aborted." -ForegroundColor Red
            return $false
        }
    }

    # Create .claude directory if needed
    if (-not $HasClaude) {
        New-Item -ItemType Directory -Path "$FullPath/.claude/commands" -Force | Out-Null
        Write-Host "  Created .claude/ folder" -ForegroundColor Green
    } else {
        if (-not (Test-Path "$FullPath/.claude/commands")) {
            New-Item -ItemType Directory -Path "$FullPath/.claude/commands" -Force | Out-Null
        }
        Write-Host "  Updated .claude/ folder" -ForegroundColor Green
    }

    # Create 01-specifications if needed
    if (-not (Test-Path "$FullPath/01-specifications")) {
        New-Item -ItemType Directory -Path "$FullPath/01-specifications" -Force | Out-Null
        Write-Host "  Created 01-specifications/" -ForegroundColor Green
    }

    # Create command files
    Set-Content -Path "$FullPath/.claude/CLAUDE.md" -Value $ClaudeMdTemplate
    Set-Content -Path "$FullPath/.claude/commands/specify.md" -Value $SpecifyCommandTemplate
    Set-Content -Path "$FullPath/.claude/commands/clarify.md" -Value $ClarifyCommandTemplate
    Set-Content -Path "$FullPath/.claude/commands/plan.md" -Value $PlanCommandTemplate
    Set-Content -Path "$FullPath/.claude/commands/tasks.md" -Value $TasksCommandTemplate
    Set-Content -Path "$FullPath/.claude/commands/track.md" -Value $TrackCommandTemplate
    Write-Host "  Created slash commands" -ForegroundColor Green

    # Detect project type
    $DetectedType = "web-app"
    if (Test-Path "$FullPath/package.json") {
        $Package = Get-Content "$FullPath/package.json" | ConvertFrom-Json
        if ($Package.dependencies) {
            if ($Package.dependencies."react-native" -or $Package.dependencies."expo") {
                $DetectedType = "mobile-app"
            } elseif ($Package.dependencies."express" -or $Package.dependencies."fastify" -or $Package.dependencies."koa") {
                $DetectedType = "api"
            }
        }
    } elseif (Test-Path "$FullPath/setup.py" -or Test-Path "$FullPath/pyproject.toml") {
        $DetectedType = "library"
    }

    # Generate project description from README if available
    $Description = "[Project description - update this]"
    $ReadmePath = Join-Path $FullPath "README.md"
    if (Test-Path $ReadmePath) {
        $ReadmeContent = Get-Content $ReadmePath -Raw -ErrorAction SilentlyContinue
        if ($ReadmeContent -and $ReadmeContent.Length -gt 50) {
            # Extract first paragraph after title
            $Lines = $ReadmeContent -split "`n"
            $DescLines = @()
            $Started = $false
            foreach ($Line in $Lines) {
                if ($Line -match "^#\s") { $Started = $true; continue }
                if ($Started -and $Line.Trim() -ne "") {
                    $DescLines += $Line.Trim()
                    if ($DescLines.Count -ge 3) { break }
                }
            }
            if ($DescLines.Count -gt 0) {
                $Description = $DescLines -join " "
            }
        }
    }

    # Create core files
    $SpecMapContent = Get-SpecMapMd -Name $DetectedName -Type $DetectedType -Description $Description
    Set-Content -Path "$FullPath/SPECMAP.md" -Value $SpecMapContent
    Write-Host "  Created SPECMAP.md" -ForegroundColor Green

    $FeaturesContent = Get-FeaturesJson -Name $DetectedName -Type $DetectedType
    Set-Content -Path "$FullPath/features.json" -Value $FeaturesContent
    Write-Host "  Created features.json" -ForegroundColor Green

    $ProgressContent = Get-ProgressMd -Name $DetectedName
    Set-Content -Path "$FullPath/progress.md" -Value $ProgressContent
    Write-Host "  Created progress.md" -ForegroundColor Green

    # Update .gitignore if it exists
    $GitIgnorePath = Join-Path $FullPath ".gitignore"
    $SpecMapIgnore = @"

# SpecMap archives
features.archive.json
"@
    if (Test-Path $GitIgnorePath) {
        $CurrentIgnore = Get-Content $GitIgnorePath -Raw
        if ($CurrentIgnore -notmatch "features\.archive\.json") {
            Add-Content -Path $GitIgnorePath -Value $SpecMapIgnore
            Write-Host "  Updated .gitignore" -ForegroundColor Green
        }
    }

    Write-Host ""
    Write-Host "SpecMap $SpecMapVersion integrated successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Detected project type: $DetectedType" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Review and update SPECMAP.md with your project details"
    Write-Host "  2. Run /specify [feature-name] to document existing or new features"
    Write-Host "  3. Update progress.md with current project state"

    return $true
}

# ============================================================================
# ENTRY POINT
# ============================================================================

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  SpecMap $SpecMapVersion Setup" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

switch ($Mode) {
    "new" {
        if (-not $ProjectName) {
            $ProjectName = Read-Host "Enter project name"
            if (-not $ProjectName) {
                Write-Host "Error: Project name is required for new projects" -ForegroundColor Red
                exit 1
            }
        }
        $Result = New-SpecMapProject -Path $ProjectPath -Name $ProjectName -Type $ProjectType
        if (-not $Result) { exit 1 }
    }
    "integrate" {
        if (-not $ProjectPath -or $ProjectPath -eq ".") {
            $ProjectPath = Get-Location
        }
        $Result = Add-SpecMapToExisting -Path $ProjectPath
        if (-not $Result) { exit 1 }
    }
}

Write-Host ""
