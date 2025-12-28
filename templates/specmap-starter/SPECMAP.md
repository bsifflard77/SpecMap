# {{PROJECT_NAME}}

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

**Type:** {{PROJECT_TYPE}}
**Created:** {{DATE}}

{{PROJECT_DESCRIPTION}}

---

## Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | [TBD] |
| Database | [TBD] |
| Libraries | [TBD] |

---

## Commands

```bash
dev:   [TBD]
test:  [TBD]
build: [TBD]
lint:  [TBD]
```

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
