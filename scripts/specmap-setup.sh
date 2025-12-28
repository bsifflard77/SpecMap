#!/bin/bash
#
# SpecMap 3.0 Setup Script
# Initialize or integrate SpecMap into any project
#
# Usage:
#   New project:      ./specmap-setup.sh new <project-name> [project-path] [project-type]
#   Existing project: ./specmap-setup.sh integrate [project-path]
#
# Examples:
#   ./specmap-setup.sh new my-app
#   ./specmap-setup.sh new my-app ~/Projects web-app
#   ./specmap-setup.sh integrate ~/Projects/existing-app
#

set -e

SPECMAP_VERSION="3.3.2"
DATE=$(date +%Y-%m-%d)
TIMESTAMP=$(date +"%Y-%m-%d %H:%M")

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# ============================================================================
# TEMPLATES
# ============================================================================

create_claude_md() {
    cat << 'CLAUDE_EOF'
# SpecMap Project Instructions

This project uses SpecMap for specification-driven development with the RULEMAP framework.

## Core Files

- `SPECMAP.md` - Project rules and conventions
- `features.json` - Feature registry with counters
- `progress.md` - Session heartbeat (update after EVERY action)

## Workflow

```
specify → clarify → plan → tasks → implement → track
```

## RULEMAP Framework

All specifications must score ≥ 8.0 across these elements:

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

Format: `[FEATURE]-[TYPE]-[NUMBER]`

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

- `/specify [concept]` - Create RULEMAP specification
- `/clarify [feature-id]` - Resolve ambiguities
- `/plan [feature-id]` - Generate implementation plan
- `/tasks [feature-id]` - Break down into TDD tasks
- `/track` - Update progress tracking

## Quality Gates

| Phase | Criteria |
|-------|----------|
| Specification | RULEMAP ≥ 8.0, no [NEEDS CLARIFICATION] |
| Planning | All decisions made, milestones defined |
| Tasks | All requirements mapped, dependencies clear |
| Implementation | Tests passing, acceptance criteria met |

## Progress Updates

After EVERY action, update progress.md:

```markdown
### [DATE]

#### Completed
- ✅ [ID]: [Description]

#### In Progress
- 🔄 [ID]: [Description]

#### Blocked
- ⛔ [ID]: Waiting on [dependency]
```
CLAUDE_EOF
}

create_specify_command() {
    cat << 'EOF'
---
description: Create a RULEMAP specification for a feature
---

# /specify

Create a comprehensive specification using the RULEMAP framework.

## Usage
`/specify [feature-name-or-concept]`

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
EOF
}

create_clarify_command() {
    cat << 'EOF'
---
description: Resolve ambiguities in a specification
---

# /clarify

Identify and resolve ambiguities in an existing specification.

## Usage
`/clarify [feature-id]`

## Process

1. **Read** the feature's spec.md
2. **Identify** all [NEEDS CLARIFICATION] markers
3. **Ask** targeted questions for each
4. **Update** spec.md with answers
5. **Re-score** RULEMAP elements
6. **Update** progress.md
EOF
}

create_plan_command() {
    cat << 'EOF'
---
description: Generate implementation plan for a feature
---

# /plan

Create a detailed implementation plan for a clarified specification.

## Usage
`/plan [feature-id]`

## Prerequisites
- Specification must have RULEMAP ≥ 8.0
- No [NEEDS CLARIFICATION] markers

## Process

1. **Verify** spec is ready (quality gate)
2. **Analyze** technical requirements
3. **Define** milestones
4. **Identify** dependencies
5. **Create** plan.md in feature folder
6. **Update** features.json with milestones
7. **Update** progress.md
EOF
}

create_tasks_command() {
    cat << 'EOF'
---
description: Break down plan into TDD tasks
---

# /tasks

Convert implementation plan into actionable TDD tasks.

## Usage
`/tasks [feature-id]`

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
EOF
}

create_track_command() {
    cat << 'EOF'
---
description: Update progress tracking
---

# /track

Update the progress.md file with current session status.

## Usage
`/track`

## Process

1. **Review** current session work
2. **Update** completed items
3. **Log** in-progress items
4. **Note** blockers
5. **Update** timestamps
EOF
}

create_specmap_md() {
    local name=$1
    local type=$2
    local description=$3

    cat << EOF
# $name

## The Mental Model

> **SpecMap treats AI like a crash-prone process with no memory guarantees.**
>
> That's why we use save files, cold start briefings, and integrity checks.

---

## What SpecMap Is NOT

- **Not a task manager** → Use Jira/Linear for that
- **Not a workflow engine** → Use n8n/Temporal for that
- **Not an agent framework** → Use LangGraph/CrewAI for that
- **Not a memory database** → Use vector DBs for that

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

---

## Project Overview

**Type:** $type
**Created:** $DATE

$description

---

## Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | [TBD] |
| Database | [TBD] |
| Libraries | [TBD] |

---

## Commands

\`\`\`bash
dev:   [TBD]
test:  [TBD]
build: [TBD]
lint:  [TBD]
\`\`\`
EOF
}

create_features_json() {
    local name=$1
    local type=$2

    cat << EOF
{
  "project": {
    "name": "$name",
    "type": "$type",
    "created": "$DATE",
    "version": "1.0.0"
  },
  "features": [],
  "counters": {
    "feature": 0,
    "requirement": 0,
    "task": 0,
    "question": 0,
    "decision": 0,
    "issue": 0,
    "acceptance": 0,
    "milestone": 0
  }
}
EOF
}

create_progress_md() {
    local name=$1

    cat << EOF
# Progress: $name

> **Last Known Good State ($TIMESTAMP):**
> Project initialized with SpecMap $SPECMAP_VERSION. No features defined yet.
> Ready to begin. No blockers. No decisions yet. Resume confidence: 5/5.

**Project:** $name
**Last Updated:** $TIMESTAMP
**Session:** #1

---

## SNAPSHOT SECTIONS (Sacred - Preserve First)

---

## Resume Confidence

| Check | Value |
|-------|-------|
| **Confidence** | 5/5 |
| **Missing Info** | None |
| **Last Verified** | $TIMESTAMP |

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
| SPECMAP.md | ~550 | ✅ Lean |
| features.json | ~200 | ✅ Lean |
| progress.md | ~500 | ✅ Lean |
| **Total Core** | **~1,250** | ✅ Under 2,000 |

> **Rule:** If Total Core exceeds 2,000 tokens, archive completed work immediately.

---

## Active Task

| Field | Value |
|-------|-------|
| **Task** | Initialize first feature |
| **ID** | TBD |
| **Feature** | TBD |
| **Started** | $TIMESTAMP |

### Cold Start Briefing

**What:** Project just initialized. Waiting for first feature to be specified.

**Why:** No features defined yet. User should run \`/specify [feature-name]\` to create first specification.

**Where:** TBD based on feature

**Current State:** SpecMap files created. Ready for first feature.

**Next Step:** Ask user what feature to build first, or wait for \`/specify\` command.

**Blockers:** None.

---

## Feature Status

| ID | Feature | Status | Progress | Blockers |
|----|---------|--------|----------|----------|
| - | (none yet) | - | - | - |

**Legend:** 🟢 Complete | 🟡 Active | ⚪ Pending | 🔴 Blocked

---

## Decisions

> **Trigger:** Any time you say "we decided..." → log it here with explicit rationale.

| ID | Decision | Rationale | Date |
|----|----------|-----------|------|
| D-001 | Using SpecMap $SPECMAP_VERSION | Standard project management framework | $DATE |

---

## HISTORY SECTIONS (Archive First When Needed)

---

## Session Log

### $DATE

#### Session 1 (Started: $TIMESTAMP)

🟢 **$TIMESTAMP** - Initialized project with SpecMap $SPECMAP_VERSION
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

\`\`\`
THE MENTAL MODEL:
SpecMap treats AI like a crash-prone process with no memory guarantees.

FOR ANY AGENT (including after context compaction):

1. READ the "Last Known Good State" at the top of this file
2. RUN Snapshot Integrity Check - fix any issues before proceeding
3. CHECK Resume Confidence - if < 3, ask user for clarification
4. READ the Cold Start Briefing in the Active Task section
5. CHECK the Decisions table for prior choices
6. SCAN Session Log for recent 🟢 entries (don't repeat these)
7. CONTINUE from where the Cold Start Briefing indicates
\`\`\`
EOF
}

# ============================================================================
# MAIN FUNCTIONS
# ============================================================================

new_project() {
    local name=$1
    local path=${2:-.}
    local type=${3:-web-app}
    local full_path="$path/$name"

    if [ -d "$full_path" ]; then
        echo -e "${RED}Error: Directory already exists: $full_path${NC}"
        exit 1
    fi

    echo ""
    echo -e "${CYAN}Creating new SpecMap project: $name${NC}"
    echo -e "${GRAY}Location: $full_path${NC}"
    echo ""

    # Create directories
    mkdir -p "$full_path/.claude/commands"
    mkdir -p "$full_path/01-specifications"
    echo -e "${GREEN}  ✓ Created directory structure${NC}"

    # Create command files
    create_claude_md > "$full_path/.claude/CLAUDE.md"
    create_specify_command > "$full_path/.claude/commands/specify.md"
    create_clarify_command > "$full_path/.claude/commands/clarify.md"
    create_plan_command > "$full_path/.claude/commands/plan.md"
    create_tasks_command > "$full_path/.claude/commands/tasks.md"
    create_track_command > "$full_path/.claude/commands/track.md"
    echo -e "${GREEN}  ✓ Created .claude/ folder with commands${NC}"

    # Create core files
    create_specmap_md "$name" "$type" "[Project description - update this]" > "$full_path/SPECMAP.md"
    echo -e "${GREEN}  ✓ Created SPECMAP.md${NC}"

    create_features_json "$name" "$type" > "$full_path/features.json"
    echo -e "${GREEN}  ✓ Created features.json${NC}"

    create_progress_md "$name" > "$full_path/progress.md"
    echo -e "${GREEN}  ✓ Created progress.md${NC}"

    # Create .gitignore
    cat > "$full_path/.gitignore" << 'GITIGNORE'
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
GITIGNORE
    echo -e "${GREEN}  ✓ Created .gitignore${NC}"

    echo ""
    echo -e "${GREEN}✓ SpecMap $SPECMAP_VERSION project created successfully!${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. cd $full_path"
    echo "  2. Update SPECMAP.md with your project description"
    echo "  3. Run /specify [feature-name] to create your first feature"
}

integrate_project() {
    local path=${1:-.}
    local full_path=$(cd "$path" 2>/dev/null && pwd)

    if [ ! -d "$full_path" ]; then
        echo -e "${RED}Error: Directory does not exist: $path${NC}"
        exit 1
    fi

    # Detect project name
    local name=$(basename "$full_path")

    # Try to get name from package.json
    if [ -f "$full_path/package.json" ]; then
        local pkg_name=$(grep '"name"' "$full_path/package.json" | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')
        if [ -n "$pkg_name" ]; then
            name=$pkg_name
        fi
    fi

    echo ""
    echo -e "${CYAN}Integrating SpecMap into existing project: $name${NC}"
    echo -e "${GRAY}Location: $full_path${NC}"
    echo ""

    # Check for existing files
    local has_specmap=false
    [ -f "$full_path/SPECMAP.md" ] && has_specmap=true
    [ -f "$full_path/features.json" ] && has_specmap=true
    [ -f "$full_path/progress.md" ] && has_specmap=true

    if [ "$has_specmap" = true ]; then
        echo -e "${YELLOW}Warning: Some SpecMap files already exist${NC}"
        read -p "Overwrite existing files? (y/N) " confirm
        if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
            echo -e "${RED}Aborted.${NC}"
            exit 1
        fi
    fi

    # Detect project type
    local type="web-app"
    if [ -f "$full_path/package.json" ]; then
        if grep -q "react-native\|expo" "$full_path/package.json" 2>/dev/null; then
            type="mobile-app"
        elif grep -q "express\|fastify\|koa" "$full_path/package.json" 2>/dev/null; then
            type="api"
        fi
    elif [ -f "$full_path/setup.py" ] || [ -f "$full_path/pyproject.toml" ]; then
        type="library"
    fi

    # Create directories
    mkdir -p "$full_path/.claude/commands"
    mkdir -p "$full_path/01-specifications"
    echo -e "${GREEN}  ✓ Created directory structure${NC}"

    # Create command files
    create_claude_md > "$full_path/.claude/CLAUDE.md"
    create_specify_command > "$full_path/.claude/commands/specify.md"
    create_clarify_command > "$full_path/.claude/commands/clarify.md"
    create_plan_command > "$full_path/.claude/commands/plan.md"
    create_tasks_command > "$full_path/.claude/commands/tasks.md"
    create_track_command > "$full_path/.claude/commands/track.md"
    echo -e "${GREEN}  ✓ Created slash commands${NC}"

    # Create core files
    create_specmap_md "$name" "$type" "[Project description - update this]" > "$full_path/SPECMAP.md"
    echo -e "${GREEN}  ✓ Created SPECMAP.md${NC}"

    create_features_json "$name" "$type" > "$full_path/features.json"
    echo -e "${GREEN}  ✓ Created features.json${NC}"

    create_progress_md "$name" > "$full_path/progress.md"
    echo -e "${GREEN}  ✓ Created progress.md${NC}"

    # Update .gitignore
    if [ -f "$full_path/.gitignore" ]; then
        if ! grep -q "features.archive.json" "$full_path/.gitignore"; then
            echo -e "\n# SpecMap archives\nfeatures.archive.json" >> "$full_path/.gitignore"
            echo -e "${GREEN}  ✓ Updated .gitignore${NC}"
        fi
    fi

    echo ""
    echo -e "${GREEN}✓ SpecMap $SPECMAP_VERSION integrated successfully!${NC}"
    echo ""
    echo -e "${GRAY}Detected project type: $type${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. Review and update SPECMAP.md with your project details"
    echo "  2. Run /specify [feature-name] to document existing or new features"
    echo "  3. Update progress.md with current project state"
}

# ============================================================================
# ENTRY POINT
# ============================================================================

echo ""
echo -e "${CYAN}================================================${NC}"
echo -e "${CYAN}  SpecMap $SPECMAP_VERSION Setup${NC}"
echo -e "${CYAN}================================================${NC}"
echo ""

case "$1" in
    new)
        if [ -z "$2" ]; then
            echo -e "${RED}Error: Project name is required${NC}"
            echo "Usage: $0 new <project-name> [project-path] [project-type]"
            exit 1
        fi
        new_project "$2" "$3" "$4"
        ;;
    integrate)
        integrate_project "$2"
        ;;
    *)
        echo "SpecMap Setup Script"
        echo ""
        echo "Usage:"
        echo "  $0 new <project-name> [project-path] [project-type]"
        echo "  $0 integrate [project-path]"
        echo ""
        echo "Examples:"
        echo "  $0 new my-app"
        echo "  $0 new my-app ~/Projects web-app"
        echo "  $0 integrate ~/Projects/existing-app"
        echo ""
        echo "Project types: web-app, mobile-app, api, library, cli"
        exit 1
        ;;
esac

echo ""
