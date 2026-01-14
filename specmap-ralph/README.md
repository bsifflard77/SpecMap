# SpecMap + Ralph

**Autonomous PRD execution for Claude Code**

Turn feature ideas into working code through structured PRDs and autonomous execution loops.

---

## Quick Start

### 1. Copy to Your Project

Copy the contents of this folder into your project root:

```
your-project/
├── .claude/
│   └── commands/
│       └── prd.md          <- /prd command
├── scripts/
│   └── ralph.ps1           <- Autonomous loop
└── templates/              <- Reference templates
    ├── PRD-TEMPLATE.md
    └── progress-TEMPLATE.md
```

### 2. Create a PRD

Use the `/prd` command in Claude Code:

```
/prd I want to add filtering to my dashboard. Users should filter by status
and date range, with the filters persisting in the URL so they can share
filtered views with teammates.
```

Claude will:
1. Analyze your input (and any existing code you reference)
2. Summarize understanding back to you
3. Ask targeted questions about gaps
4. Present scope options (Minimal/Standard/Full)
5. Generate a PRD with checkbox-based stories
6. Create progress.md for tracking
7. Commit and push to GitHub

### 3. Execute Autonomously

Run the Ralph loop:

```powershell
.\scripts\ralph.ps1
```

Ralph will:
- Read progress.md to know where to continue
- Complete ONE criterion per iteration
- Update PRD.md checkboxes as work completes
- Commit after each criterion
- Push to GitHub after each story completes
- Stop when all stories are done (or hit limits)

---

## How It Works

### The Two-File System

| File | Purpose | Updated |
|------|---------|---------|
| **PRD.md** | What needs doing (checkboxes) | When criteria complete |
| **progress.md** | Where we are RIGHT NOW | Every iteration |

### The Flow

```
/prd [your idea]
    ↓
Claude analyzes, asks questions
    ↓
You pick scope → Claude drafts PRD
    ↓
You approve → Files created, pushed to GitHub
    ↓
ralph.ps1 runs autonomous loop
    ↓
Each iteration: Read progress → Do ONE criterion → Update files → Commit
    ↓
On story complete: Push to GitHub
    ↓
All done → Final push
```

### Smart Limits

- **5 attempts per story** - Prevents stuck loops
- **50 total iterations** - Safety cap
- **Push after each story** - Work is always backed up
- **Pull before resume** - Catches external changes

---

## Commands

### /prd Command

```
/prd [description]
```

**Input modes:**
- **Brain dump**: Describe your idea in your own words
- **Existing work**: Point to files/folders to analyze
- **Hybrid**: Both context and existing work references
- **Minimal**: Just a feature name (Claude asks more questions)

**Examples:**
```
# Brain dump
/prd I want a dark mode toggle that persists user preference

# Existing work reference
/prd Review src/components - I want to add a search feature

# Hybrid (most common)
/prd I've built a task manager (see src/). Now add filtering by status
```

### ralph.ps1 Options

```powershell
# Basic run
.\ralph.ps1

# Continue from where we left off
.\ralph.ps1 -Resume

# Skip a problematic story
.\ralph.ps1 -Skip "US-003"

# Increase retry limit
.\ralph.ps1 -MaxIterationsPerStory 8

# No iteration caps (run until complete)
.\ralph.ps1 -UntilComplete

# See what would run without executing
.\ralph.ps1 -DryRun

# Custom file paths
.\ralph.ps1 -PRDPath "./specs/PRD.md" -ProgressPath "./specs/progress.md"
```

### Exit Codes

| Code | Meaning |
|------|---------|
| 0 | All stories complete |
| 1 | Max total iterations reached |
| 2 | Max per-story iterations reached |
| 3 | Stuck on same error 3x |
| 4 | PRD.md not found |
| 5 | progress.md not found |

---

## PRD Structure

```markdown
# PRD: Feature Name

**Status**: Draft | Approved | In Progress | Complete
**Stories**: 5 total | **Complete**: 2 | **Remaining**: 3

## Stories

### US-001: Story Title [STATUS]
**Depends**: None
**Files**: `src/component.tsx`

- [x] First criterion (completed)
- [x] Second criterion (completed)
- [ ] Third criterion (in progress)  <- Ralph works here
- [ ] Typecheck passes
- [ ] Tests pass
```

**Status emojis:** Pending | In Progress | Complete | Blocked | Paused

---

## progress.md Structure

```markdown
# Progress

## Cold Start Briefing

> Read this first. Tells you exactly where to pick up.

**Story**: US-002 - Date Filter
**Criterion**: Add date picker component
**State**: Story started, working on first criterion
**Next Action**: Create DatePicker.tsx
**Files**: `src/components/DatePicker.tsx`
**Rollback**: abc123 - "feat: add status filter"
**Last Push**: 2024-01-14 15:30:00 (after US-001)

## Learnings

> Patterns discovered. Read BEFORE starting work.

- Use formatDate() from utils, don't recreate (2024-01-14 14:30)
- Tests need NODE_ENV=test (2024-01-14 14:45)
```

---

## Git Push Strategy

Work is automatically backed up:

| Event | Action |
|-------|--------|
| PRD approved | Push PRD.md + progress.md |
| Story complete | Push when story goes to Complete |
| ralph.ps1 exit | Push on any exit (complete, stuck, interrupted) |
| Resume | Pull first to catch external changes |

---

## Tips

### Writing Good Criteria

**Good (specific, verifiable):**
- Add `status` column to tasks table with default 'pending'
- FilterDropdown renders options: All, Active, Completed
- API returns 400 if date range invalid

**Bad (vague):**
- Works correctly
- Good UX
- Handles edge cases

### Story Order

Always order by dependency:
1. Schema/Database changes
2. Types/Interfaces
3. Backend logic
4. Hooks/State
5. UI components
6. Integration/Polish

### When Stuck

If Ralph keeps failing on a story:
1. Check progress.md Learnings section
2. Fix the issue manually
3. Resume: `.\ralph.ps1 -Resume`

Or skip and continue: `.\ralph.ps1 -Skip "US-003"`

---

## Requirements

- **Claude Code** CLI installed and authenticated
- **Git** repository initialized
- **PowerShell** (Windows) or PowerShell Core (cross-platform)

---

## License

MIT
