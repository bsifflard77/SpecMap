# SpecMap + Ralph Integration: Phase 1 Specification

**Version**: 1.0.0-draft
**Created**: 2024-01-14
**Status**: Draft - Pending Review

---

## Executive Summary

Phase 1 delivers the **Minimum Viable SpecMap+Ralph Integration**:

- **PRD.md**: Checkbox-based story tracking (the "what")
- **progress.md**: ~300 token save file (the "where we are")
- **/prd command**: Interactive PRD development with Claude Code
- **ralph.ps1**: Autonomous execution loop with smart limits

**Goal**: Enable Claude Code to collaboratively build a PRD with the user, then autonomously execute it story-by-story with fresh context per iteration.

---

## Table of Contents

1. [Core Concepts](#1-core-concepts)
2. [PRD.md Template](#2-prdmd-template)
3. [progress.md Template](#3-progressmd-template)
4. [/prd Command Specification](#4-prd-command-specification)
5. [ralph.ps1 Specification](#5-ralphps1-specification)
6. [End-to-End Example](#6-end-to-end-example)
7. [Error Handling & Edge Cases](#7-error-handling--edge-cases)
8. [Success Criteria](#8-success-criteria)

---

## 1. Core Concepts

### 1.1 The Two-Phase Model

```
PHASE A: PRD Development (Interactive)
├── Step 1: User Input
│   ├── User brain dumps / describes their vision
│   ├── OR user points to existing code/docs to review
│   └── OR user provides both (vision + existing work)
│
├── Step 2: Claude Analyzes
│   ├── Reviews any existing code, docs, or context
│   ├── Summarizes understanding back to user
│   └── Identifies gaps and ambiguities
│
├── Step 3: Clarification (Targeted)
│   ├── Claude asks ONLY what's unclear or missing
│   ├── Skips questions already answered by user input
│   └── User fills in the gaps
│
├── Step 4: Scope & PRD
│   ├── Claude proposes scope options with trade-offs
│   ├── User picks scope
│   ├── Claude drafts PRD, user reviews and refines
│   └── User approves final PRD
│
└── Output: PRD.md + progress.md

PHASE B: Execution (Autonomous)
├── ralph.ps1 runs iterations
├── Each iteration = fresh Claude context
├── One criterion per iteration
├── Updates PRD.md (checkboxes) and progress.md (state)
└── Output: Working code + git commits
```

### 1.2 User Input Modes

The `/prd` command accepts multiple input modes:

**Mode 1: Brain Dump**
User describes their vision in their own words - as much or as little as they want.
```
/prd I want to build a YouTube enhancement tool called YTidy. It should help
users manage their subscriptions, organize playlists, bulk delete watch
history, and provide analytics on their viewing habits. The main pain point
is that YouTube's native tools are scattered and clunky...
```

**Mode 2: Existing Work Reference**
User points Claude to existing code, docs, or previous work to analyze first.
```
/prd Review the src/features folder and the README - I want to add a new
feature for bulk playlist management
```

**Mode 3: Hybrid (Most Common)**
User provides both context and points to existing materials.
```
/prd I've been building YTidy (see src/ and docs/). Now I want to add
subscription grouping - letting users create folders for their subscriptions
like "Tech", "Music", "News" and filter their feed by group.
```

**Mode 4: Minimal**
User provides just a feature name - Claude asks more questions.
```
/prd subscription grouping feature
```

Claude adapts its question depth based on how much context the user provides upfront.

### 1.3 The Save File Philosophy

**progress.md is the heartbeat.** It enables:

- Any Claude instance to continue work cold
- Knowledge transfer between iterations (Learnings)
- Debugging and audit trail (timestamps)
- Rollback capability (commit references)

**If progress.md isn't updated, the system is broken.**

### 1.4 The One Context Window Rule

Each story criterion must be completable in ONE context window (~10 min of AI work).

**Right-sized criteria:**
- Add a database column
- Create a single component
- Add one API endpoint
- Write tests for one function

**Too big (split it):**
- "Build the dashboard"
- "Add authentication"
- "Refactor the API"

### 1.5 Token Budget

| File | Target | Purpose |
|------|--------|---------|
| progress.md Cold Start Briefing | ~200 tokens | Immediate context |
| Active story from PRD.md | ~150 tokens | Current work |
| **Total iteration context** | **~350 tokens** | Leaves room for reasoning |

Full PRD.md and other files loaded ON DEMAND only.

### 1.6 Git Push Strategy

**All work must be backed up to GitHub.** Local commits without pushes are at risk.

#### Push Points

| Event | Action | Rationale |
|-------|--------|-----------|
| `/prd` approval | Push PRD.md + progress.md | Backup specification before execution |
| Story completion | Push when story goes ✅ | Meaningful checkpoint (not every criterion) |
| ralph.ps1 exit | Push on any exit | Capture work whether complete, stuck, or interrupted |
| Session resume | Pull before starting | Catch external changes, avoid conflicts |

#### Implementation

**In ralph.ps1:**
```powershell
# After story completion
function Push-ToRemote {
    git push origin HEAD 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  📤 Pushed to remote" -ForegroundColor Green
    } else {
        Write-Warning "  Push failed - continue locally, push manually later"
    }
}

# On any exit (register at script start)
Register-EngineEvent PowerShell.Exiting -Action {
    git push origin HEAD 2>&1 | Out-Null
}
```

**In /prd command:**
```
After "approve":
1. Save PRD.md
2. Save progress.md
3. Git add + commit
4. Git push
5. Confirm: "✅ PRD saved and pushed to GitHub"
```

#### Tracking in progress.md

Add to Cold Start Briefing:
```markdown
**Last Push**: [YYYY-MM-DD HH:MM:SS] (after [story or event])
```

#### Failure Handling

If push fails (network issue, auth problem):
- Log warning but continue execution
- Track in progress.md: `**Push Status**: ⚠️ Pending (last attempt failed)`
- Retry on next push point
- Show reminder at session end if pushes pending

#### Pull Before Resume

When starting with `-Resume`:
```powershell
# Check for remote changes
$status = git status -uno
if ($status -match "behind") {
    Write-Warning "Remote has changes. Pulling..."
    git pull --rebase origin HEAD
}
```

### 1.7 Fresh Session Per Story (Critical Rule)

**Each story MUST start in a fresh Claude Code session.**

This is the core principle that makes SpecMap work:

```
Story US-001 complete
    ↓
Git commit + push
    ↓
Claude STOPS and tells user: "US-001 complete. Start a new session for US-002."
    ↓
User opens new Claude Code session
    ↓
New session reads progress.md Cold Start Briefing
    ↓
Fresh context window for US-002
```

#### Why This Matters

| Problem | Solution |
|---------|----------|
| Context window fills up over long sessions | Fresh session = full context available |
| Previous story's code/errors pollute context | Clean slate for each story |
| Hard to recover from confused state | Just start new session, read progress.md |
| Token budget exceeded | Each story gets full budget |

#### Implementation

**Claude MUST stop after completing a story:**
```
✅ US-001 complete
📤 Pushed to GitHub

To continue with US-002:
1. Close this session (or start fresh with /clear)
2. Open a new Claude Code session
3. Say: "start US-002" or "continue from progress.md"

The Cold Start Briefing in progress.md has everything needed to resume.
```

**Claude MUST NOT:**
- Automatically continue to the next story in the same session
- Ask "should I continue with US-002?" and then proceed
- Skip the session boundary

**The Cold Start Briefing exists precisely for this purpose** - it contains all context needed for a new session to pick up exactly where the previous one left off.

#### Manual Override

If user explicitly says "continue in this session" or "don't stop", Claude may proceed. But the default behavior is always: **stop and prompt for new session**.

---

## 2. PRD.md Template

### 2.1 Structure

```markdown
# PRD: [Feature Name]

**Created**: [YYYY-MM-DD HH:MM:SS]
**Status**: Draft | Approved | In Progress | Complete
**Scope**: [Minimal | Standard | Full]
**Stories**: [X total] | **Complete**: [Y] | **Remaining**: [Z]

---

## Overview

**Problem**: [One sentence: what problem does this solve?]
**Solution**: [One sentence: what are we building?]
**User**: [Who benefits from this?]

---

## Scope Boundaries

**In Scope**:
- [What's included]
- [What's included]

**Out of Scope**:
- [What's explicitly excluded]
- [What's explicitly excluded]

---

## Stories

### US-001: [Story Title] [STATUS_EMOJI]
**Depends**: None | US-XXX
**Files**: `path/to/file.ts`

- [ ] [Criterion 1 - specific, verifiable]
- [ ] [Criterion 2 - specific, verifiable]
- [ ] Typecheck passes
- [ ] Tests pass

---

### US-002: [Story Title] [STATUS_EMOJI]
**Depends**: US-001
**Files**: `path/to/file.ts`, `path/to/other.ts`

- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] Typecheck passes
- [ ] Tests pass
- [ ] Verify changes work in browser

---

[Continue for all stories...]

---

## Decisions Log

| ID | Decision | Rationale | Date |
|----|----------|-----------|------|
| D-001 | [What was decided] | [Why] | [Date] |

---

## Assumptions

| Assumption | Confidence | Validated |
|------------|------------|-----------|
| [Assumption] | High/Med/Low | Yes/No |

```

### 2.2 Status Emojis

| Emoji | Meaning |
|-------|---------|
| ⏳ | Pending (not started) |
| 🔄 | In Progress (current story) |
| ✅ | Complete (all criteria [x]) |
| ❌ | Blocked (cannot proceed) |
| ⏸️ | Paused (user requested stop) |

### 2.3 Criterion Rules

**Every criterion MUST be:**
- Specific (not vague)
- Verifiable (can check if done)
- Atomic (one thing, not multiple)

**Always include for EVERY story:**
```markdown
- [ ] Typecheck passes
- [ ] Tests pass
```

**For UI stories, also include:**
```markdown
- [ ] Verify changes work in browser
```

**Good criteria examples:**
```markdown
- [ ] Add `status` column to tasks table with default 'pending'
- [ ] FilterDropdown renders options: All, Active, Completed
- [ ] Clicking delete shows confirmation dialog
- [ ] API returns 400 if date range invalid
```

**Bad criteria (too vague):**
```markdown
- [ ] Works correctly
- [ ] Good UX
- [ ] Handles edge cases
- [ ] User can do X easily
```

### 2.4 Story Ordering Rules

Stories MUST be ordered by dependency:

```
1. Schema/Database changes (migrations)
2. Types/Interfaces
3. Server actions / Backend logic
4. Hooks / State management
5. UI components
6. Integration / Polish
```

**Wrong order (will fail):**
```markdown
US-001: Create UI component     ← Uses hook that doesn't exist!
US-002: Create hook             ← Uses types that don't exist!
US-003: Define types
```

**Correct order:**
```markdown
US-001: Define types
US-002: Create hook
US-003: Create UI component
```

---

## 3. progress.md Template

### 3.1 Structure (~300 tokens target)

```markdown
# Progress

**Feature**: [Feature Name]
**PRD**: PRD.md
**Started**: [YYYY-MM-DD HH:MM:SS]
**Last Updated**: [YYYY-MM-DD HH:MM:SS]
**Status**: In Progress | Complete | Paused

---

## Cold Start Briefing

> Read this first. It tells you exactly where to pick up.

**Story**: US-[XXX] - [Story Title]
**Criterion**: [The specific criterion being worked on]
**State**: [What's done, what's not]
**Next Action**: [Literal next step to take]
**Files**: `path/to/file.ts`
**Rollback**: [commit hash] - [commit message snippet]
**Last Push**: [YYYY-MM-DD HH:MM:SS] (after [story/event]) | None yet

---

## Learnings

> Patterns and gotchas discovered. Read BEFORE starting work.

- [Learning 1] (discovered [YYYY-MM-DD HH:MM])
- [Learning 2] (discovered [YYYY-MM-DD HH:MM])
- [Learning 3] (discovered [YYYY-MM-DD HH:MM])

---

## Iteration Log

### #[N] - [YYYY-MM-DD HH:MM:SS]
**Story**: US-[XXX] | **Criterion**: [Which one]
**Status**: ✅ Complete | ❌ Failed | ⏸️ Paused
**Duration**: [X] min
**Commit**: `[commit message]` | None (failed)
**Notes**: [Brief notes, what was learned]

---

### #[N-1] - [YYYY-MM-DD HH:MM:SS]
**Story**: US-[XXX] | **Criterion**: [Which one]
**Status**: ✅ Complete
**Duration**: [X] min
**Commit**: `[commit message]`

---

[Keep last 5-10 iterations, archive older ones]

---

## Story Summary

| Story | Title | Status | Iterations |
|-------|-------|--------|------------|
| US-001 | [Title] | ✅ | 2 |
| US-002 | [Title] | ✅ | 3 |
| US-003 | [Title] | 🔄 | 1 (in progress) |
| US-004 | [Title] | ⏳ | - |

```

### 3.2 Cold Start Briefing Rules

The Cold Start Briefing MUST be updated after EVERY iteration.

**It answers these questions:**
1. Which story? (US-XXX)
2. Which criterion within that story?
3. What's the current state?
4. What's the literal next action?
5. What files are involved?
6. Where to rollback if things break?

**Example - In Progress:**
```markdown
## Cold Start Briefing

**Story**: US-003 - Date Range Filter
**Criterion**: Validate range (end > start)
**State**: Date picker component added, validation logic not started
**Next Action**: Add validateDateRange() function in src/utils/filters.ts
**Files**: `src/utils/filters.ts`, `src/components/DateRangePicker.tsx`
**Rollback**: a1b2c3d - "feat: add date picker component"
**Last Push**: 2024-01-14 14:52:00 (after US-002)
```

**Example - After Failure:**
```markdown
## Cold Start Briefing

**Story**: US-003 - Date Range Filter
**Criterion**: Validate range (end > start)
**State**: Validation added but tests failing - expects ISO format
**Next Action**: Fix validateDateRange() to use ISO string comparison
**Files**: `src/utils/filters.ts`
**Rollback**: a1b2c3d - "feat: add date picker component"
**Last Push**: 2024-01-14 14:52:00 (after US-002)
**Previous Attempt**: Failed - used timestamp comparison, DatePicker uses ISO
```

**Example - Story Complete, Moving to Next:**
```markdown
## Cold Start Briefing

**Story**: US-004 - URL Persistence
**Criterion**: Sync filter state to URL params
**State**: Starting fresh - US-003 just completed
**Next Action**: Add URL sync logic to useFilter hook
**Files**: `src/hooks/useFilter.ts`
**Rollback**: b2c3d4e - "feat: add date range validation"
**Last Push**: 2024-01-14 15:05:00 (after US-003 ✅)
```

### 3.3 Learnings Section Rules

Learnings transfer knowledge between iterations. They should be:

- **Specific**: Not "be careful" but "DatePicker expects ISO format"
- **Actionable**: How to apply the learning
- **Timestamped**: When it was discovered

**Good learnings:**
```markdown
- Use formatDate() from src/utils/date.ts, don't create new formatter (2024-01-14 10:30)
- FilterDropdown expects options as {label, value} objects (2024-01-14 11:15)
- Tests require NODE_ENV=test or database calls fail (2024-01-14 11:45)
```

**Bad learnings (too vague):**
```markdown
- Be careful with dates
- Tests are tricky
- The API is weird
```

### 3.4 Iteration Log Rules

Log every iteration, success or failure.

**Required fields:**
- Timestamp (YYYY-MM-DD HH:MM:SS)
- Story ID
- Criterion being worked on
- Status (✅ ❌ ⏸️)
- Duration
- Commit (if successful)
- Notes (brief)

**Keep last 5-10 iterations in progress.md.** Archive older ones to `progress.archive.md` if needed.

---

## 4. /prd Command Specification

### 4.1 Overview

The `/prd` command initiates interactive PRD development with Claude Code.

```
/prd [user input - brain dump, existing work reference, or both]
```

**Examples:**
```
# Brain dump mode
/prd I want to build a YouTube tool called YTidy that helps users manage
subscriptions, organize playlists, and track viewing analytics. The main
problem is YouTube's native tools are scattered and hard to use...

# Existing work reference
/prd Review src/features and README.md - I want to add bulk playlist management

# Hybrid (most common)
/prd I've been building YTidy (see src/ and docs/). Now I want to add
subscription grouping - folders for subs like "Tech", "Music", "News"

# Minimal (Claude will ask more questions)
/prd subscription grouping feature
```

### 4.2 The PRD Development Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│  STEP 1: RECEIVE USER INPUT                                             │
│  ─────────────────────────────                                          │
│  Claude receives whatever the user provides:                            │
│  • Brain dump / vision description                                      │
│  • Reference to existing code/docs                                      │
│  • Both                                                                  │
│  • Just a feature name                                                  │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│  STEP 2: ANALYZE & RESEARCH                                             │
│  ──────────────────────────────                                         │
│  If user pointed to existing work:                                      │
│  • Review referenced files/folders                                      │
│  • Understand existing patterns, tech stack, conventions                │
│  • Identify how new feature fits with existing code                     │
│  • Note reusable components and integration points                      │
│                                                                         │
│  From brain dump:                                                       │
│  • Extract stated requirements                                          │
│  • Note user's language and priorities                                  │
│  • Identify what's clear vs. ambiguous                                  │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│  STEP 3: SUMMARIZE UNDERSTANDING                                        │
│  ─────────────────────────────────                                      │
│  Claude plays back what it understood:                                  │
│                                                                         │
│  "Based on your description and the existing code, here's what I        │
│   understand:                                                           │
│                                                                         │
│   You want to add [feature] that does [X, Y, Z].                        │
│   The main problem it solves is [problem].                              │
│   Target users are [users].                                             │
│                                                                         │
│   From reviewing the codebase:                                          │
│   • Tech stack: [Next.js, Prisma, etc.]                                 │
│   • Existing patterns: [how similar features work]                      │
│   • Integration points: [where this hooks in]                           │
│   • Reusable components: [what we can leverage]                         │
│                                                                         │
│   Is this accurate? Anything to add or correct?"                        │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│  STEP 4: TARGETED CLARIFICATION                                         │
│  ───────────────────────────────                                        │
│  Claude asks ONLY about gaps - things not covered by user input:        │
│                                                                         │
│  "I have a few questions about things I couldn't determine:             │
│                                                                         │
│   1. [Only if unclear] How should X behave when Y?                      │
│      A. Option A                                                        │
│      B. Option B                                                        │
│      C. Other                                                           │
│                                                                         │
│   2. [Only if unclear] What happens if Z fails?                         │
│      A. Option A                                                        │
│      B. Option B"                                                       │
│                                                                         │
│  If user provided comprehensive input, this might be just 1-2 questions │
│  or even: "I think I have everything I need. Ready to show scope        │
│  options?"                                                              │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│  STEP 5: SCOPE OPTIONS                                                  │
│  ──────────────────────                                                 │
│  (Continues as before - see Section 4.3)                                │
└─────────────────────────────────────────────────────────────────────────┘
```

### 4.3 Question Framework (For Gaps Only)

When Claude needs to ask clarifying questions, use these categories as a **checklist**, not a rigid sequence. Skip any category already covered by user input.

```
WHAT (Scope & Requirements)
├── What problem does this solve?           ← Skip if user stated this
├── What should it do?                      ← Skip if user described features
├── What should it NOT do?                  ← Often needs asking
└── What's the priority?                    ← Often needs asking

WHO (Users & Stakeholders)
├── Who will use this?                      ← Skip if obvious from context
├── Who decides if it's done?               ← Usually needs asking
└── Who needs to approve?                   ← Usually needs asking

HOW (Implementation)
├── How should it behave? (happy path)      ← Skip if user described
├── How should errors be handled?           ← Often needs asking
├── How does it integrate?                  ← Skip if Claude reviewed code
└── How should it look/feel?                ← Often needs asking

WHAT IF (Edge Cases)
├── What if the user does X?                ← Often needs asking
├── What if the API fails?                  ← Often needs asking
├── What if data is missing?                ← Often needs asking
└── What if there are no results?           ← Often needs asking
```

**Question Format (when needed):**
```
1. [Question text]
   A. [Option A]
   B. [Option B]
   C. [Option C]
   D. Other: [describe]
```

**User can respond:**
- Letter only: "A" or "1A"
- Multiple: "1A, 2B, 3C"
- Freeform: "Actually, I want..."
- Skip: "skip" (if already clear)
- Done: "done" (ready to see draft)

### 4.4 Scope Options

After gathering requirements, Claude MUST present scope options:

```markdown
Based on your requirements, here are scope options:

**Option A: Minimal (3 stories, ~30 min)**
✓ Basic filter by status
✓ Persists in URL
✗ No saved presets
✗ No date range

**Option B: Standard (5 stories, ~50 min)** ← Recommended
✓ Filter by status + date range
✓ Persists in URL
✓ Clear filters button
✗ No saved presets

**Option C: Full (8 stories, ~80 min)**
✓ Everything in B
✓ Saved filter presets (up to 3)
✓ Keyboard shortcuts
✓ Filter suggestions

Which scope? (A/B/C)
```

### 4.5 Draft Review Loop

After user selects scope, Claude drafts PRD.md and presents for review:

```
Claude: Here's the draft PRD:

        [Shows PRD content]

        Does this look right? You can:
        - "approve" - Save and proceed
        - "add [story]" - Add a story
        - "remove US-XXX" - Remove a story
        - "split US-XXX" - Break into smaller stories
        - "change [description]" - Modify something
        - "questions" - Ask me anything about the PRD
```

**Loop continues until user says "approve".**

### 4.6 Output

When approved, `/prd` creates and pushes:

1. **PRD.md** - The feature specification with stories
2. **progress.md** - Initialized with Cold Start Briefing pointing to US-001
3. **Git commit + push** - Backup to GitHub immediately

```
Claude: ✅ PRD.md saved (5 stories, ~50 min estimated)
        ✅ progress.md initialized
        ✅ Committed: "feat: add PRD for [feature name]"
        📤 Pushed to remote

        To execute autonomously:
          ralph.ps1

        To execute manually (story by story):
          "start US-001"
```

**If push fails:**
```
Claude: ✅ PRD.md saved (5 stories, ~50 min estimated)
        ✅ progress.md initialized
        ✅ Committed: "feat: add PRD for [feature name]"
        ⚠️  Push failed (check network/auth) - committed locally

        To push manually:
          git push origin HEAD

        To execute autonomously:
          ralph.ps1
```

### 4.7 Assumptions Handling

During PRD development, Claude tracks assumptions:

```markdown
## Assumptions I'm Making

| Assumption | Confidence | Action |
|------------|------------|--------|
| Using existing Button component | High | Proceed |
| Filter state in URL params | Medium | Confirmed by user |
| No mobile-specific requirements | Low | **Need to ask** |

I'm making a low-confidence assumption about mobile. Should this work on mobile, or desktop only?
```

**Low-confidence assumptions MUST be validated before PRD approval.**

---

## 5. ralph.ps1 Specification

### 5.1 Parameters

```powershell
param(
    [int]$MaxIterationsPerStory = 5,     # Max attempts per story
    [int]$MaxTotalIterations = 50,        # Absolute cap
    [int]$SleepSeconds = 2,               # Pause between iterations
    [switch]$UntilComplete = $false,      # Override: no caps
    [switch]$Resume = $false,             # Continue from progress.md
    [string]$Skip = "",                   # Skip a story: -Skip "US-003"
    [switch]$DryRun = $false              # Show prompt, don't execute
)
```

### 5.2 Iteration Prompt

```
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
   - Update PRD.md: If all story criteria [x], mark story ✅
   - Git commit: `feat: [brief description]`
   - Update progress.md:
     - Add iteration log entry with timestamp
     - Update Cold Start Briefing to NEXT criterion
     - Add any learnings discovered
     - Update Story Summary table

7. If ANY verification FAILS:
   - Do NOT mark criterion [x]
   - Do NOT commit
   - Update progress.md:
     - Add iteration log entry (status: ❌)
     - Update Cold Start Briefing with failure details
     - Add learnings (what went wrong)

## End Signal

After updating progress.md, check PRD.md:
- If ALL stories show ✅: Output `<promise>COMPLETE</promise>`
- If stories remain with [ ]: End response (next iteration continues)

## Critical Rules

- ONE criterion per iteration
- ALWAYS update progress.md (even on failure)
- Learnings section is your memory between iterations
- Cold Start Briefing must reflect current state
- Include timestamp on all updates: [YYYY-MM-DD HH:MM:SS]
```

### 5.3 Loop Logic

```powershell
# Register exit handler to always push on exit
$script:exitPushRegistered = $false
function Register-ExitPush {
    if (-not $script:exitPushRegistered) {
        Register-EngineEvent PowerShell.Exiting -Action {
            Push-ToRemote -Reason "session exit"
        }
        $script:exitPushRegistered = $true
    }
}

function Push-ToRemote {
    param([string]$Reason = "checkpoint")

    $result = git push origin HEAD 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  📤 Pushed to remote ($Reason)" -ForegroundColor Green
        Update-ProgressLastPush $Reason
    } else {
        Write-Warning "  Push failed ($Reason) - continue locally"
        Update-ProgressPushStatus "⚠️ Pending"
    }
}

function Pull-BeforeResume {
    $status = git fetch origin 2>&1
    $behind = git rev-list HEAD..origin/HEAD --count 2>&1
    if ($behind -gt 0) {
        Write-Host "  📥 Remote has $behind new commits. Pulling..." -ForegroundColor Yellow
        git pull --rebase origin HEAD
    }
}

# Main loop
Register-ExitPush

if ($Resume) {
    Pull-BeforeResume
}

$previousStory = $null

for ($i = 1; $i -le $MaxTotalIterations; $i++) {

    # Track per-story attempts
    $currentStory = Get-CurrentStoryFromProgress
    $storyAttempts = Get-StoryAttempts $currentStory

    if ($storyAttempts -ge $MaxIterationsPerStory -and -not $UntilComplete) {
        Write-Warning "Story $currentStory failed $MaxIterationsPerStory times. Stopping."
        Show-StuckReport $currentStory
        Push-ToRemote -Reason "stuck on $currentStory"
        exit 2
    }

    # Run iteration
    $result = Invoke-ClaudeIteration $prompt

    # Check if story just completed (transitioned to next story)
    $newStory = Get-CurrentStoryFromProgress
    if ($previousStory -and $newStory -ne $previousStory) {
        Push-ToRemote -Reason "$previousStory complete"
    }
    $previousStory = $newStory

    # Check for completion
    if ($result -match "<promise>COMPLETE</promise>") {
        Push-ToRemote -Reason "all stories complete"
        Show-CompletionSummary
        exit 0
    }

    # Check for stuck (same error 3 times)
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
```

### 5.4 Exit Codes

| Code | Meaning |
|------|---------|
| 0 | All stories complete |
| 1 | Max total iterations reached |
| 2 | Max per-story iterations reached |
| 3 | Stuck on same error |
| 4 | PRD.md not found |
| 5 | progress.md not found |

### 5.5 Completion Summary

When all stories complete:

```
═══════════════════════════════════════════════════════════
  ✅ ALL STORIES COMPLETE
═══════════════════════════════════════════════════════════

  Feature: Dashboard Filters
  Total Iterations: 12
  Total Duration: 47 minutes

  Stories:
  ├── US-001: Filter Dropdown       ✅ (2 iterations)
  ├── US-002: Date Range Picker     ✅ (3 iterations)
  ├── US-003: Filter State Hook     ✅ (4 iterations)
  ├── US-004: URL Persistence       ✅ (2 iterations)
  └── US-005: Empty State           ✅ (1 iteration)

  Commits:
  ├── a1b2c3d - feat: add filter dropdown component
  ├── b2c3d4e - feat: add date range picker
  ├── c3d4e5f - feat: add filter state hook
  ├── d4e5f6g - feat: sync filters to URL
  └── e5f6g7h - feat: add empty state for filters

  Next Steps:
  1. Review commits: git log --oneline -10
  2. Test in browser: npm run dev
  3. Merge to main: git checkout main && git merge feature/dashboard-filters

═══════════════════════════════════════════════════════════
```

### 5.6 Stuck Report

When stopping due to repeated failures:

```
═══════════════════════════════════════════════════════════
  ⚠️  STOPPED - Story US-003 failed 5 times
═══════════════════════════════════════════════════════════

  Current State:
  ├── Story: US-003 - Date Range Validation
  ├── Criterion: Validate range (end > start)
  ├── Attempts: 5
  └── Last Error: Tests failing - expected ISO format

  Recent Learnings:
  ├── DatePicker returns ISO strings
  ├── Comparison fails with timestamps
  └── Need to use date-fns compareAsc()

  Rollback Point: a1b2c3d - "feat: add date picker"

  Options:
  1. Fix manually, then resume:
     ralph.ps1 -Resume

  2. Skip this story, continue others:
     ralph.ps1 -Skip "US-003"

  3. Increase retry limit:
     ralph.ps1 -MaxIterationsPerStory 8

  4. Review progress.md for details:
     Get-Content progress.md

═══════════════════════════════════════════════════════════
```

---

## 6. End-to-End Example

### 6.1 Starting the PRD Development

**Example A: Brain Dump Mode**

```
User: /prd I want to add filtering to my task dashboard. Users should be able
      to filter by status (active, completed, archived) and by date range.
      The filters should persist in the URL so users can share filtered views
      with teammates. When no tasks match, show an empty state with a clear
      filters button. I also want date presets like "Today", "Last 7 days",
      "Last 30 days" for quick filtering. This is for all users, not just admins.

Claude: Great, you've given me a clear picture. Let me summarize what I understand:

        **Feature**: Dashboard Filtering
        **Problem**: Users need to find specific tasks in potentially long lists
        **Solution**: Status + date range filters with URL persistence

        **What you've specified:**
        ✓ Filter by status (active/completed/archived)
        ✓ Filter by date range with presets (Today, 7d, 30d)
        ✓ Persist in URL (shareable)
        ✓ Empty state with "Clear filters" button
        ✓ For all users

        **A few things I'd like to clarify:**

        1. What happens if someone loads an invalid URL (e.g., bad date format)?
           A. Silently ignore invalid params, show unfiltered
           B. Show error message, then show unfiltered
           C. Redirect to clean URL

        2. Should the filters work on mobile too?
           A. Yes, same UI
           B. Yes, but we can optimize for mobile later
           C. Desktop only for now

User: 1A, 2B

Claude: Perfect. Based on everything, here are scope options:
```

**Example B: Existing Work Reference**

```
User: /prd Review the src/components and src/hooks folders - I want to add
      filtering to the existing TaskList component

Claude: I've reviewed your codebase. Here's what I found:

        **Existing Structure:**
        • TaskList component at src/components/TaskList.tsx
        • Uses React Query for data fetching (src/hooks/useTasks.ts)
        • Existing UI components: Button, Dropdown, DatePicker in src/ui/
        • Current task model has: id, title, status, createdAt, updatedAt

        **Patterns I noticed:**
        • State management via URL params (useSearchParams)
        • Tailwind CSS for styling
        • Tests in __tests__ folders alongside components

        **Integration points:**
        • Filter UI would go in TaskList or new TaskFilters component
        • Filter logic would extend useTasks hook
        • URL sync already has patterns to follow

        To build the PRD, I need to understand what you want:

        1. What should users be able to filter by?
           A. Status only (matches current task.status field)
           B. Status + date range (createdAt or updatedAt?)
           C. Status + date range + search query
           D. Other: [describe]

        2. Any specific requirements I should know about?

User: 1B - filter by createdAt. And I want the filters to persist in URL
      like the existing pagination does.

Claude: Got it. I see the pagination URL pattern in useTasks.ts - I'll follow
        that same approach. Here are scope options:
```

**Example C: Hybrid Mode (Most Common)**

```
User: /prd I've been building a YouTube enhancement tool called YTidy (see
      src/ and the README). Now I want to add subscription grouping - letting
      users create folders for their subscriptions like "Tech", "Music",
      "News" and filter their feed by group. The main pain point is YouTube
      doesn't let you organize subscriptions at all.

Claude: I've reviewed your YTidy codebase and README. Here's my understanding:

        **Existing YTidy Features (from your code):**
        • Subscription list management (src/features/subscriptions/)
        • YouTube API integration (src/services/youtube-api.ts)
        • Local storage for user preferences
        • Chrome extension architecture

        **New Feature: Subscription Grouping**
        • Problem: YouTube has no way to organize subscriptions
        • Solution: User-created groups/folders for subscriptions
        • Use case: Filter feed to show only "Tech" subscriptions

        **Technical fit:**
        • Groups would be stored in local storage (like existing preferences)
        • Subscription-to-group mapping in new data structure
        • Feed filtering would intercept YouTube's API responses

        **What I understand you want:**
        ✓ Create/edit/delete groups ("Tech", "Music", etc.)
        ✓ Assign subscriptions to groups
        ✓ Filter YouTube feed by group

        **Questions about gaps:**

        1. Can a subscription belong to multiple groups?
           A. No, one group only (simpler)
           B. Yes, multiple groups (more flexible)

        2. What happens to ungrouped subscriptions?
           A. Show in "Ungrouped" default group
           B. Always visible (groups are additive filter)
           C. Hide until grouped (forces organization)

        3. Should groups sync across devices?
           A. No, local only (simpler, works now)
           B. Yes, need cloud sync (more complex, future feature)

User: 1B, 2A, 3A for now

Claude: Perfect. Here are scope options:

        **Option A: Minimal (3 stories, ~30 min)**
        ✓ Filter by status (dropdown)
        ✓ Persist in URL
        ✓ Empty state with clear button
        ✗ No date range
        ✗ No presets

        **Option B: Standard (5 stories, ~50 min)** ← Recommended
        ✓ Filter by status (dropdown)
        ✓ Filter by date range
        ✓ Date presets (Today, 7d, 30d)
        ✓ Persist in URL
        ✓ Empty state with clear button

        **Option C: Full (7 stories, ~70 min)**
        ✓ Everything in B
        ✓ Mobile-optimized UI (bottom sheet)
        ✓ Keyboard shortcuts (Cmd+F to focus)

        Which scope? (A/B/C)

User: B

Claude: Here's the draft PRD:

        ---
        # PRD: Dashboard Filters

        **Created**: 2024-01-14 14:30:00
        **Status**: Draft
        **Scope**: Standard
        **Stories**: 5 total

        ## Overview

        **Problem**: Users can't find specific items in long dashboard lists.
        **Solution**: Add status and date range filters with URL persistence.
        **User**: All dashboard users.

        ## Scope Boundaries

        **In Scope**:
        - Filter by status (active/completed/archived)
        - Filter by date range with presets
        - URL persistence (shareable links)
        - Empty state with clear button

        **Out of Scope**:
        - Custom tags filtering
        - Mobile-specific UI
        - Keyboard shortcuts
        - Saved filter presets

        ## Stories

        ### US-001: Status Filter Dropdown ⏳
        **Depends**: None
        **Files**: `src/components/StatusFilter.tsx`

        - [ ] Create StatusFilter component with options: All, Active, Completed, Archived
        - [ ] Style to match existing dropdown components
        - [ ] Typecheck passes
        - [ ] Tests pass

        ### US-002: Date Range Filter ⏳
        **Depends**: None
        **Files**: `src/components/DateRangeFilter.tsx`

        - [ ] Create DateRangeFilter with start/end date pickers
        - [ ] Add preset buttons: Today, Last 7 days, Last 30 days
        - [ ] Validate end date >= start date
        - [ ] Typecheck passes
        - [ ] Tests pass

        ### US-003: Filter State Management ⏳
        **Depends**: US-001, US-002
        **Files**: `src/hooks/useFilters.ts`

        - [ ] Create useFilters hook managing status and date state
        - [ ] Connect to StatusFilter and DateRangeFilter components
        - [ ] Typecheck passes
        - [ ] Tests pass

        ### US-004: URL Persistence ⏳
        **Depends**: US-003
        **Files**: `src/hooks/useFilters.ts`

        - [ ] Sync filter state to URL search params
        - [ ] Restore filter state from URL on page load
        - [ ] Handle invalid URL params gracefully
        - [ ] Typecheck passes
        - [ ] Tests pass

        ### US-005: Empty State ⏳
        **Depends**: US-003
        **Files**: `src/components/FilterEmptyState.tsx`

        - [ ] Create FilterEmptyState component
        - [ ] Show "No items match your filters" message
        - [ ] Add "Clear all filters" button that resets state
        - [ ] Typecheck passes
        - [ ] Tests pass
        - [ ] Verify changes work in browser

        ## Assumptions

        | Assumption | Confidence | Validated |
        |------------|------------|-----------|
        | Using existing DatePicker component | High | Yes |
        | URL params use standard format | High | Yes |
        | Dashboard already has item list | High | Yes |
        ---

        Does this look right? You can:
        - "approve" - Save and proceed
        - "add [description]" - Add a story
        - "remove US-XXX" - Remove a story
        - "split US-XXX" - Break into smaller stories
        - "change [description]" - Modify something

User: approve

Claude: ✅ PRD.md saved (5 stories, ~50 min estimated)
        ✅ progress.md initialized

        Files created:
        - PRD.md - Feature specification
        - progress.md - Execution state tracker

        To execute autonomously:
          .\ralph.ps1

        To execute one story at a time:
          "start US-001"
```

### 6.2 Initial progress.md (After /prd)

```markdown
# Progress

**Feature**: Dashboard Filters
**PRD**: PRD.md
**Started**: 2024-01-14 14:35:00
**Last Updated**: 2024-01-14 14:35:00
**Status**: Ready

---

## Cold Start Briefing

**Story**: US-001 - Status Filter Dropdown
**Criterion**: Create StatusFilter component with options: All, Active, Completed, Archived
**State**: Not started - beginning fresh
**Next Action**: Create StatusFilter.tsx in src/components/
**Files**: `src/components/StatusFilter.tsx`
**Rollback**: None yet (first story)
**Last Push**: 2024-01-14 14:35:00 (PRD approved)

---

## Learnings

> None yet - first iteration.

---

## Iteration Log

> No iterations yet.

---

## Story Summary

| Story | Title | Status | Iterations |
|-------|-------|--------|------------|
| US-001 | Status Filter Dropdown | ⏳ | - |
| US-002 | Date Range Filter | ⏳ | - |
| US-003 | Filter State Management | ⏳ | - |
| US-004 | URL Persistence | ⏳ | - |
| US-005 | Empty State | ⏳ | - |
```

### 6.3 Running Ralph Loop

```
User: .\ralph.ps1

═══════════════════════════════════════════════════════════
  Starting Ralph - Max 5 per story, 50 total iterations
═══════════════════════════════════════════════════════════

═══════════════════════════════════════════════════════════
  Iteration 1 of 50
═══════════════════════════════════════════════════════════

[Claude reads progress.md, implements US-001 criterion 1]
[Creates StatusFilter.tsx]
[Runs typecheck - passes]
[Updates PRD.md - marks criterion [x]]
[Commits: "feat: create StatusFilter component"]
[Updates progress.md]

═══════════════════════════════════════════════════════════
  Iteration 2 of 50
═══════════════════════════════════════════════════════════

[Claude reads progress.md, continues US-001 criterion 2]
[Styles StatusFilter to match existing dropdowns]
[Runs typecheck - passes]
[Updates PRD.md - marks criterion [x]]
[Commits: "feat: style StatusFilter dropdown"]
[Updates progress.md]

... continues ...

═══════════════════════════════════════════════════════════
  Iteration 12 of 50
═══════════════════════════════════════════════════════════

[Claude reads progress.md, implements US-005 final criterion]
[Verifies in browser - works]
[Updates PRD.md - marks all US-005 criteria [x], marks US-005 ✅]
[Commits: "feat: add filter empty state"]
[Updates progress.md]
[All stories ✅ - outputs <promise>COMPLETE</promise>]

═══════════════════════════════════════════════════════════
  ✅ ALL STORIES COMPLETE - 12 iterations
═══════════════════════════════════════════════════════════
```

### 6.4 Final PRD.md (After Completion)

```markdown
# PRD: Dashboard Filters

**Created**: 2024-01-14 14:30:00
**Status**: Complete
**Scope**: Standard
**Stories**: 5 total | **Complete**: 5 | **Remaining**: 0

---

## Overview

**Problem**: Users can't find specific items in long dashboard lists.
**Solution**: Add status and date range filters with URL persistence.
**User**: All dashboard users.

---

## Stories

### US-001: Status Filter Dropdown ✅
**Depends**: None
**Files**: `src/components/StatusFilter.tsx`

- [x] Create StatusFilter component with options: All, Active, Completed, Archived
- [x] Style to match existing dropdown components
- [x] Typecheck passes
- [x] Tests pass

---

### US-002: Date Range Filter ✅
**Depends**: None
**Files**: `src/components/DateRangeFilter.tsx`

- [x] Create DateRangeFilter with start/end date pickers
- [x] Add preset buttons: Today, Last 7 days, Last 30 days
- [x] Validate end date >= start date
- [x] Typecheck passes
- [x] Tests pass

---

### US-003: Filter State Management ✅
**Depends**: US-001, US-002
**Files**: `src/hooks/useFilters.ts`

- [x] Create useFilters hook managing status and date state
- [x] Connect to StatusFilter and DateRangeFilter components
- [x] Typecheck passes
- [x] Tests pass

---

### US-004: URL Persistence ✅
**Depends**: US-003
**Files**: `src/hooks/useFilters.ts`

- [x] Sync filter state to URL search params
- [x] Restore filter state from URL on page load
- [x] Handle invalid URL params gracefully
- [x] Typecheck passes
- [x] Tests pass

---

### US-005: Empty State ✅
**Depends**: US-003
**Files**: `src/components/FilterEmptyState.tsx`

- [x] Create FilterEmptyState component
- [x] Show "No items match your filters" message
- [x] Add "Clear all filters" button that resets state
- [x] Typecheck passes
- [x] Tests pass
- [x] Verify changes work in browser

---

## Decisions Log

| ID | Decision | Rationale | Date |
|----|----------|-----------|------|
| D-001 | Use URL params not localStorage | Shareable links requirement | 2024-01-14 |
| D-002 | ISO format for date params | Consistent with existing API | 2024-01-14 |
```

### 6.5 Final progress.md (After Completion)

```markdown
# Progress

**Feature**: Dashboard Filters
**PRD**: PRD.md
**Started**: 2024-01-14 14:35:00
**Last Updated**: 2024-01-14 15:22:00
**Status**: Complete

---

## Cold Start Briefing

**Story**: Complete - All stories done
**State**: Feature fully implemented and verified
**Commits**: 12 total (see iteration log)
**Next Action**: Merge to main branch
**Last Push**: 2024-01-14 15:22:00 (all stories complete)

---

## Learnings

- Use existing DatePicker from src/components/ui - don't recreate (2024-01-14 14:52)
- URL params should use ISO format for dates (2024-01-14 15:05)
- useSearchParams hook needs 'use client' directive (2024-01-14 15:08)
- Empty state should check both filter count AND results count (2024-01-14 15:20)

---

## Iteration Log

### #12 - 2024-01-14 15:22:00
**Story**: US-005 | **Criterion**: Verify changes work in browser
**Status**: ✅ Complete
**Duration**: 3 min
**Commit**: `feat: add filter empty state`
**Notes**: All criteria pass, story complete

---

### #11 - 2024-01-14 15:19:00
**Story**: US-005 | **Criterion**: Add "Clear all filters" button
**Status**: ✅ Complete
**Duration**: 4 min
**Commit**: `feat: add clear filters button`

---

[... iterations 3-10 ...]

---

### #2 - 2024-01-14 14:45:00
**Story**: US-001 | **Criterion**: Style to match existing dropdowns
**Status**: ✅ Complete
**Duration**: 5 min
**Commit**: `feat: style StatusFilter dropdown`

---

### #1 - 2024-01-14 14:38:00
**Story**: US-001 | **Criterion**: Create StatusFilter component
**Status**: ✅ Complete
**Duration**: 8 min
**Commit**: `feat: create StatusFilter component`
**Notes**: First iteration, component structure established

---

## Story Summary

| Story | Title | Status | Iterations |
|-------|-------|--------|------------|
| US-001 | Status Filter Dropdown | ✅ | 2 |
| US-002 | Date Range Filter | ✅ | 3 |
| US-003 | Filter State Management | ✅ | 3 |
| US-004 | URL Persistence | ✅ | 2 |
| US-005 | Empty State | ✅ | 2 |
| **Total** | | | **12** |
```

---

## 7. Error Handling & Edge Cases

### 7.1 PRD.md Not Found

```
Ralph: ❌ PRD.md not found in current directory.

       To create a PRD:
         /prd [feature description]

       Or specify a path:
         ralph.ps1 -PRDPath "./specs/PRD.md"
```

### 7.2 progress.md Not Found

```
Ralph: ❌ progress.md not found.

       Creating from PRD.md...
       ✅ progress.md initialized

       Continuing with iteration 1...
```

### 7.3 PRD and Progress Out of Sync

```
Ralph: ⚠️  State mismatch detected.

       progress.md says: US-003 in progress
       PRD.md shows: US-003 all criteria [x]

       Options:
       1. Trust PRD.md (mark US-003 complete, move to US-004)
       2. Trust progress.md (revert PRD.md, retry US-003)
       3. Stop for manual review

       Choosing option 1 (PRD.md is source of truth for completion)
```

### 7.4 User Interruption

If user needs to stop Ralph mid-execution:

```
User: Ctrl+C

Ralph: ⏸️  Interrupted at iteration 7.

       Current state saved to progress.md:
       - Story: US-003
       - Criterion: Connect to filter components
       - State: Hook created, connection in progress

       To resume:
         ralph.ps1 -Resume
```

### 7.5 PRD Changes Mid-Execution

If user modifies PRD.md while Ralph is running:

```
Ralph: ⚠️  PRD.md changed externally.

       Detected changes:
       - US-006 added: "Keyboard Shortcuts"
       - US-003 criterion modified

       Options:
       1. Accept changes, continue from current story
       2. Restart from first incomplete story
       3. Stop for manual review

       Stopping for manual review (safest option).

       To continue with changes:
         ralph.ps1 -Resume -AcceptChanges
```

---

## 8. Success Criteria

### 8.1 Phase 1 is Complete When

- [ ] PRD.md template documented and validated
- [ ] progress.md template documented and validated (~300 tokens)
- [ ] /prd command implemented with interactive question flow
- [ ] ralph.ps1 implemented with smart limits
- [ ] End-to-end test: Create PRD → Run Ralph → All stories complete
- [ ] Error handling covers all edge cases in Section 7
- [ ] Documentation complete (this spec)

### 8.2 Quality Gates

| Metric | Target |
|--------|--------|
| progress.md token count | < 350 tokens |
| PRD development time | < 10 min for standard scope |
| Iteration success rate | > 80% (criteria pass on first attempt) |
| Context efficiency | < 500 tokens loaded per iteration |

### 8.3 User Acceptance

- User can create PRD through natural conversation
- User understands scope options and trade-offs
- User can review and modify PRD before execution
- User can monitor progress during Ralph loop
- User can resume after interruption
- User can understand what went wrong on failure

---

## Appendix A: File Locations

```
project/
├── PRD.md                    # Feature specification (created by /prd)
├── progress.md               # Execution state (created by /prd)
├── progress.archive.md       # Old iterations (created when log > 10)
└── .specmap/
    └── ralph.ps1             # Execution script
```

---

## Appendix B: Command Reference

| Command | Purpose |
|---------|---------|
| `/prd [feature]` | Start interactive PRD development |
| `ralph.ps1` | Run autonomous execution loop |
| `ralph.ps1 -Resume` | Continue from progress.md state |
| `ralph.ps1 -Skip "US-XXX"` | Skip a problematic story |
| `ralph.ps1 -MaxIterationsPerStory 8` | Increase retry limit |
| `ralph.ps1 -UntilComplete` | No iteration caps |
| `ralph.ps1 -DryRun` | Show prompt without executing |

---

## Appendix C: Token Budget Reference

| Component | Target | Notes |
|-----------|--------|-------|
| Cold Start Briefing | ~150 | Always loaded |
| Active story criteria | ~100 | Always loaded |
| Learnings section | ~50 | Always loaded |
| **Tier 1 Total** | **~300** | Loaded every iteration |
| Full PRD.md | ~500 | On demand |
| CLAUDE.md | ~300 | On demand (Phase 2) |
| **Max Context** | **~1,100** | If everything loaded |

---

*End of Phase 1 Specification*
