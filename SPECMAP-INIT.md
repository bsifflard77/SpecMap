# SpecMap 3.3.2 Project Bootstrap

<!-- 
╔═══════════════════════════════════════════════════════════════════╗
║                        HOW TO USE                                  ║
╠═══════════════════════════════════════════════════════════════════╣
║  1. Drag this file into your new project folder                   ║
║  2. Tell your AI agent: "Read SPECMAP-INIT.md and set up this     ║
║     project"                                                       ║
║  3. Answer the agent's questions                                   ║
║  4. Agent creates all project files                                ║
║  5. This file is deleted when setup is complete                    ║
╚═══════════════════════════════════════════════════════════════════╝

THE MENTAL MODEL:
SpecMap treats AI like a crash-prone process with no memory guarantees.
That's why we use save files, cold start briefings, and integrity checks.

WHAT SPECMAP IS NOT:
• Not a task manager (use Jira/Linear)
• Not a workflow engine (use n8n/Temporal)
• Not an agent framework (use LangGraph/CrewAI)
• Not a memory database (use vector DBs)

SpecMap IS a state persistence layer. It interfaces with all of the above.

VERSION: 3.3.2
-->

---

## AGENT INSTRUCTIONS

You are initializing a new project with SpecMap 3.3.2.

**The Mental Model:**
> SpecMap treats AI like a crash-prone process with no memory guarantees.

**SpecMap Core = 3 files designed as SAVE FILES (not logs):**
- `SPECMAP.md` - Project rules (you read this first, always)
- `features.json` - What we're building (intent)
- `progress.md` - What's happening (reality) - **updated after EVERY action**

**The One Rule That Cannot Break:**
> If progress.md isn't updated, SpecMap is broken.
> Everything else can be imperfect. This cannot.

**The Save File Philosophy:**
> A brand new agent with zero prior context should be able to read 
> progress.md and continue immediately. Design for cold start.

**Priority Under Pressure:**
> If forced to choose, preserve snapshot over history.
> When in doubt, delete history before touching snapshot sections.

**Follow these steps exactly.**

---

## STEP 1: ASK THESE QUESTIONS

Ask the user each question. Wait for all answers before proceeding.

### Project Basics (Required)
1. What is the project name?
2. Describe the project in 2-3 sentences. What does it do?
3. Who is the target user?

### Tech Stack (Required)
4. What framework? (e.g., Next.js 14, React Native, Python FastAPI, Node/Express)
5. What database? (e.g., PostgreSQL, MongoDB, SQLite, Supabase, none)
6. Key libraries? (e.g., Prisma, TailwindCSS, Stripe, Auth.js) - or "none yet"

### Features (Required)
7. List 3-7 features this project needs. For each:
   - Feature name
   - One sentence description
   - Priority: high / medium / low

### Environment (Required)
8. What environment variables will you need? (e.g., DATABASE_URL, API keys, or "standard defaults")

### Optional - Say "skip" or "defaults" to use defaults
9. Any specific coding standards? (default: standard best practices)
10. Enable GitHub issue sync? (default: no)
11. External security scanning? (default: built-in only)

---

## STEP 2: CREATE FILES

After collecting answers, create these files in order:

---

### FILE 1: `.env`

```
# ═══════════════════════════════════════════════════════════════
# [PROJECT_NAME] Environment Variables
# Created: [TIMESTAMP]
# ═══════════════════════════════════════════════════════════════
# ⚠️  NEVER commit this file to git
# ═══════════════════════════════════════════════════════════════

# ====================
# REQUIRED
# ====================

# Database
DATABASE_URL=

# App
NODE_ENV=development
PORT=3000

# [ADD BASED ON USER ANSWERS FROM Q8]

# ====================
# OPTIONAL (if enabled)
# ====================

# GitHub Sync (if Q10 = yes)
GITHUB_TOKEN=

# External Security (if Q11 = snyk/socket)
SNYK_TOKEN=
```

---

### FILE 2: `.env.example`

```
# ═══════════════════════════════════════════════════════════════
# [PROJECT_NAME] Environment Variables  
# Copy this file to .env and fill in your values
# ═══════════════════════════════════════════════════════════════

# Database connection string
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# App environment
NODE_ENV=development
PORT=3000

# [ADD BASED ON USER ANSWERS WITH EXAMPLE VALUES]
```

---

### FILE 3: `.gitignore`

```
# Environment (NEVER commit)
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

# SpecMap archives (optional - may contain sensitive context)
features.archive.json

# SpecMap: DO commit SPECMAP.md, features.json, progress.md
```

---

### FILE 4: `SPECMAP.md`

```markdown
# [PROJECT_NAME]

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

## ⚠️ CRITICAL RULES - READ THIS FIRST

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
8. Do NOT repeat 🟢 completed work

## After EVERY Completed Action

1. Add 🟢 entry to Session Log: `🟢 **HH:MM** - [What you did]`
2. Add 2-4 bullet points of specifics
3. Update Feature Status table if needed
4. Update **Active Task** including Cold Start Briefing
5. Update **Last Known Good State** (top of file)
6. Update **Resume Confidence**
7. Update **Context Budget** if significantly changed
8. Save progress.md IMMEDIATELY

## When Ending a Session

1. Add `🟡 **HH:MM** - Session ended` entry with:
   - Current active task
   - Current state summary
   - What to do next (resume point)
2. Update **Last Known Good State**
3. Run **Snapshot Integrity Check**
4. Ensure **Cold Start Briefing** is complete enough for a new agent

---

## 🛑 Critical Operations (Require Human Approval)

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

## 🔄 Compaction Recovery Protocol

If you notice loss of context, confusion, or uncertainty:

1. **STOP** - Do not guess or continue blindly
2. **READ** progress.md from the top (Last Known Good State)
3. **RUN** Snapshot Integrity Check
4. **READ** the Cold Start Briefing in Active Task
5. **CHECK** the Decisions table for prior choices
6. **UPDATE** Resume Confidence (probably 2/5 or lower)
7. **ASK** if confidence < 3: "I may have lost context. Should I proceed with [Active Task] or do you need to brief me?"

**DO NOT:**
- Assume you remember the conversation
- Repeat completed work (check 🟢 entries)
- Make decisions that contradict the Decisions table
- Execute Critical Operations without re-confirming

---

## Adding New Work

| Type | Where to Add | Trigger |
|------|--------------|---------|
| New feature | features.json + Feature Status table | — |
| New task | features.json → tasks array | — |
| Quick idea | Backlog section in progress.md | — |
| Decision | Decisions table in progress.md | "We decided..." |

**NEVER create separate task files or to-do documents.**

---

## Source of Truth

| File | Contains | Updates When |
|------|----------|--------------|
| features.json | Intent - what should exist | Feature added/completed |
| progress.md | Reality - what actually happened | **After EVERY action** |

---

## Project Overview

[PROJECT_DESCRIPTION]

**Target User:** [TARGET_USER]

---

## Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | [FRAMEWORK] |
| Database | [DATABASE] |
| Libraries | [LIBRARIES] |

---

## Commands

```bash
dev:   [DEV_COMMAND]
test:  [TEST_COMMAND]
build: [BUILD_COMMAND]
lint:  [LINT_COMMAND]
```

---

## 🔒 Security Checklist

### Before Every Commit
```bash
# Check for hardcoded secrets (should return empty)
grep -rn "API_KEY\|SECRET\|PASSWORD\|TOKEN\|sk-\|pk_" src/ 2>/dev/null || echo "✓ No secrets found"
```

- [ ] No hardcoded secrets
- [ ] No .env files being committed  
- [ ] Linter passes

### Before Feature Complete
- [ ] All tasks completed
- [ ] Acceptance criteria passing
- [ ] Security check passed
- [ ] Tests passing
- [ ] No Critical Operations pending

---

## Standards

[CODING_STANDARDS or defaults:]
- Meaningful variable names
- Functions do one thing
- Tests required before marking complete
- Commit format: `feat(scope): description` or `fix(scope): description`

---

## VERIFICATION CHECKLIST

Before responding, verify:
- [ ] Did I read progress.md first?
- [ ] Did I check Last Known Good State?
- [ ] Did I run Snapshot Integrity Check?
- [ ] Did I check Resume Confidence?
- [ ] Am I continuing from Active Task, not starting over?
- [ ] After my work, did I update progress.md with timestamp?
- [ ] Did I update the Cold Start Briefing?
- [ ] Are new tasks in features.json, not separate files?
- [ ] Did I log any decisions with explicit rationale?
- [ ] Did I ask approval for any Critical Operations?

**If any box is unchecked, fix it before responding.**
```

---

### FILE 5: `features.json`

```json
{
  "project": "[PROJECT_NAME]",
  "version": "0.1.0",
  "created": "[TIMESTAMP]",
  "updated": "[TIMESTAMP]",
  
  "features": [
    {
      "id": "001",
      "name": "[FEATURE_NAME from Q7]",
      "description": "[FEATURE_DESCRIPTION]",
      "priority": "[high/medium/low]",
      "status": "pending",
      "tasks": [
        {
          "id": "001-T-001",
          "description": "[First logical task]",
          "status": "pending"
        },
        {
          "id": "001-T-002",
          "description": "[Second task]",
          "status": "pending"
        }
      ],
      "acceptance": [
        {
          "id": "001-A-001",
          "description": "[Testable: User can do X]",
          "passing": false
        }
      ],
      "completed_at": null
    }
  ],
  
  "backlog": [],
  "decisions": []
}
```

**RULES:**
- 2-4 tasks per feature (logical breakdown)
- 1-3 acceptance criteria per feature (must be testable)
- IDs: `[FEATURE]-T-[NUM]` for tasks, `[FEATURE]-A-[NUM]` for acceptance
- Keep it lean: archive to `features.archive.json` when you have 5+ completed features

---

### FILE 6: `progress.md`

```markdown
# Progress Tracker

> **Last Known Good State ([TIMESTAMP]):**  
> Project initialized with [X] features, [Y] total tasks. Ready to begin Feature 001 
> ([FIRST_FEATURE_NAME]). No work completed yet. No blockers. No decisions yet. 
> Resume confidence: 5/5.

**Project:** [PROJECT_NAME]  
**Last Updated:** [TIMESTAMP]  
**Session:** #1

---

## SNAPSHOT SECTIONS (Sacred - Preserve First)

---

## Resume Confidence

| Check | Value |
|-------|-------|
| **Confidence** | 5/5 |
| **Missing Info** | None |
| **Last Verified** | [TIMESTAMP] |

> If confidence < 3, clarify with user before proceeding.

---

## ✓ Snapshot Integrity Check

Before proceeding, verify:
- [ ] Last Known Good State reflects current reality
- [ ] Active Task matches Feature Status table
- [ ] Cold Start Briefing is accurate and complete
- [ ] Resume Confidence is set honestly
- [ ] Decisions table includes recent choices

> If any box is unchecked, fix it before doing new work.

---

## 📊 Context Budget (Estimated)

| File | Est. Tokens | Status |
|------|-------------|--------|
| SPECMAP.md | ~550 | ✅ Lean |
| features.json | ~[ESTIMATE] | ✅ Lean |
| progress.md | ~500 | ✅ Lean |
| **Total Core** | **~[TOTAL]** | ✅ Under 2,000 |

> **Rule:** If Total Core exceeds 2,000 tokens, archive completed work immediately.
> **Priority:** If forced to choose, preserve snapshot over history.
> **When in doubt:** Delete history before touching snapshot sections.

---

## 🟡 Active Task

| Field | Value |
|-------|-------|
| **Task** | [First task from Feature 001] |
| **ID** | 001-T-001 |
| **Feature** | 001 - [FIRST_FEATURE_NAME] |
| **Started** | [TIMESTAMP] |

### Cold Start Briefing

**What:** [Clear description of what this task accomplishes]

**Why:** First task of Feature 001 ([FEATURE_NAME]). This feature [brief description of feature purpose]. No dependencies - this is the starting point.

**Where:** [Files/directories that will be created or modified - or "TBD based on implementation"]

**Current State:** Project just initialized. No code written yet. Ready to begin.

**Next Step:** [Specific first action to take]

**Blockers:** None.

---

## Feature Status

| ID | Feature | Status | Progress | Blockers |
|----|---------|--------|----------|----------|
| 001 | [Name] | ⚪ | 0/[X] | None |
| 002 | [Name] | ⚪ | 0/[X] | None |
[GENERATE FOR EACH FEATURE]

**Legend:** 🟢 Complete | 🟡 Active | ⚪ Pending | 🔴 Blocked

---

## Decisions

> **Trigger:** Any time you say "we decided..." → log it here with explicit rationale.
> **Requirement:** Include alternatives considered and why this choice was made.

| ID | Decision | Rationale (Alternatives Considered) | Date |
|----|----------|-------------------------------------|------|
| D-001 | Tech stack: [FRAMEWORK] + [DATABASE] | Based on project requirements. [Framework] chosen for [reason]. [Database] chosen for [reason]. | [DATE] |

---

## HISTORY SECTIONS (Archive First When Needed)

---

## Session Log

### [TODAY'S DATE]

#### Session 1 (Started: [TIME])

🟢 **[TIME]** - Initialized project with SpecMap 3.3.2
   - Created SPECMAP.md with project rules and Critical Operations
   - Created features.json with [X] features, [Y] tasks
   - Created progress.md with Cold Start Briefing and Integrity Check
   - Set up environment files (.env, .env.example)
   - Initialized git repository
   - Ready to begin Feature 001: [FEATURE_NAME]

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

```
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

AFTER EVERY COMPLETED ACTION:
1. Add: 🟢 **HH:MM** - [What you completed]
2. Add 2-4 bullet points with specifics
3. Update the Cold Start Briefing for the next action
4. Update Last Known Good State
5. Update Resume Confidence  
6. Save IMMEDIATELY

WHEN ENDING A SESSION:
1. Add: 🟡 **HH:MM** - Session ended
   - Active: [current task]
   - State: [what's done, what's next]
   - Resume: [specific next step]
2. Run Snapshot Integrity Check
3. Ensure Cold Start Briefing is complete for cold restart

DECISION TRIGGER:
• Any time you say "we decided..." → add to Decisions table
• Include: what was decided, alternatives considered, why this choice

CRITICAL OPERATIONS:
• Check SPECMAP.md for list of operations requiring human approval
• STOP and ASK before executing any of them

CONTEXT BUDGET:
• If total tokens > 2,000, archive before continuing
• Priority: preserve snapshot sections over history sections
• When in doubt: delete history before touching snapshot sections

ARCHIVE HIERARCHY:
KEEP (Sacred):              DELETE FIRST (History):
─────────────────────       ─────────────────────
Last Known Good State       Old session log entries
Snapshot Integrity Check    Resolved questions
Resume Confidence           Cleared blockers
Context Budget              Completed backlog items
Active Task + Cold Start    
Feature Status              
Recent Decisions            
```
```

---

## STEP 3: INITIALIZE GIT

```bash
git init
git add .
git commit -m "chore: Initialize project with SpecMap 3.3.2"
```

---

## STEP 4: DELETE THIS FILE

```bash
rm SPECMAP-INIT.md
git add -A && git commit -m "chore: Remove bootstrap file"
```

---

## STEP 5: REPORT TO USER

```
═══════════════════════════════════════════════════════════════════
✅ SpecMap 3.3.2 Setup Complete
═══════════════════════════════════════════════════════════════════

🧠 Mental Model:
   SpecMap treats AI like a crash-prone process with no memory guarantees.
   That's why we use save files, cold start briefings, and integrity checks.

📁 Core Files Created:
   • SPECMAP.md      - Project rules + Critical Operations + Recovery Protocol
   • features.json   - [X] features, [Y] tasks defined
   • progress.md     - Save file with Cold Start Briefing + Integrity Check

📁 Environment Files:
   • .env            - Configure your values here
   • .env.example    - Template reference
   • .gitignore      - Protecting sensitive files

📋 Features Ready:
   001 [Feature 1] - [priority] - [X tasks]
   002 [Feature 2] - [priority] - [X tasks]
   ...

📊 Context Budget:
   SPECMAP.md:      ~550 tokens
   features.json:   ~[X] tokens
   progress.md:     ~500 tokens
   Total:           ~[Y] tokens ✅ Under 2,000

🚀 Next Steps:
   1. Configure .env with your values
   2. Install dependencies
   3. I'll begin with: 001-T-001 - [First task description]

💡 How This Works:
   • I read progress.md at the start of every session
   • I run Snapshot Integrity Check before proceeding
   • I update progress.md after every completed action
   • The Cold Start Briefing lets any agent continue immediately
   • You can step away, switch agents, or recover from compaction seamlessly

⚠️  The One Rule:
   If progress.md isn't updated, SpecMap is broken.
   Everything else can be imperfect. This cannot.

📦 Archive Hierarchy (when context budget tight):
   KEEP: Last Known Good State, Cold Start Briefing, Decisions
   DELETE FIRST: Old session logs, resolved questions, cleared blockers
   When in doubt: delete history before touching snapshot sections.

🛑 Critical Operations:
   I'll ask before: deleting files, migrations, production API calls,
   git operations on main, or anything that costs money.

═══════════════════════════════════════════════════════════════════
```

---

## FINAL CHECKLIST

Before reporting completion:

- [ ] Asked questions 1-8 (required) and 9-11 (optional)
- [ ] Created .env with variables from Q8
- [ ] Created .env.example with placeholders
- [ ] Created .gitignore protecting .env and archives
- [ ] Created SPECMAP.md with:
  - [ ] Mental Model statement
  - [ ] What SpecMap Is NOT section
  - [ ] Critical Operations list
  - [ ] Compaction Recovery Protocol
  - [ ] Priority Under Pressure + archive hierarchy
  - [ ] Verification Checklist
- [ ] Created features.json with all features from Q7
- [ ] Created progress.md with:
  - [ ] SNAPSHOT SECTIONS header (sacred)
  - [ ] HISTORY SECTIONS header (archivable)
  - [ ] Last Known Good State (top of file)
  - [ ] Resume Confidence table
  - [ ] Snapshot Integrity Check
  - [ ] Context Budget table with archive guidance
  - [ ] Cold Start Briefing in Active Task
  - [ ] Decisions table with rationale requirement
  - [ ] Resume Instructions with archive hierarchy
- [ ] Each feature has 2-4 tasks and 1-3 acceptance criteria
- [ ] Initialized git with commit
- [ ] Deleted this SPECMAP-INIT.md file
- [ ] Reported summary with archive hierarchy guidance

**Setup complete when all boxes checked.**

---

## SPECMAP CORE VS EXTENDED (Reference)

**This bootstrap creates SpecMap Core.** That's all most projects need.

### SpecMap Core (Created by This File)
```
SPECMAP.md       → Rules + Critical Operations + Recovery Protocol
features.json    → Intent  
progress.md      → Reality (save file with Cold Start Briefing)
```

### SpecMap Extended (Add Later If Needed)
```
.specmap/agents/       → Custom AI agents
.specmap/commands/     → Slash commands
.specmap/workflows/    → Automation
features.archive.json  → Completed features (for context budget)
GitHub sync            → Issues ↔ features
MCP Server             → Protocol-based state access
Vector DB              → Long-term semantic memory
RULEMAP Full           → 7-element PRD scoring
External security      → Snyk/Socket integration
```

> **Important:** SpecMap **interfaces with** these systems. It does not **absorb** them.
> SpecMap's power is that it stays boring, legible, and portable.

**Start with Core. Add Extended features only when you need them.**
