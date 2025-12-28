# Progress: {{PROJECT_NAME}}

> **Last Known Good State ({{TIMESTAMP}}):**
> Project initialized with SpecMap 3.3.2. No features defined yet.
> Ready to begin. No blockers. No decisions yet. Resume confidence: 5/5.

**Project:** {{PROJECT_NAME}}
**Last Updated:** {{TIMESTAMP}}
**Session:** #1

---

## SNAPSHOT SECTIONS (Sacred - Preserve First)

---

## Resume Confidence

| Check | Value |
|-------|-------|
| **Confidence** | 5/5 |
| **Missing Info** | None |
| **Last Verified** | {{TIMESTAMP}} |

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
| **Started** | {{TIMESTAMP}} |

### Cold Start Briefing

**What:** Project just initialized. Waiting for first feature to be specified.

**Why:** No features defined yet. User should run `/specify [feature-name]` to create first specification.

**Where:** TBD based on feature

**Current State:** SpecMap files created. Ready for first feature.

**Next Step:** Ask user what feature to build first, or wait for `/specify` command.

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
| D-001 | Using SpecMap 3.3.2 | Standard project management framework | {{DATE}} |

---

## HISTORY SECTIONS (Archive First When Needed)

---

## Session Log

### {{DATE}}

#### Session 1 (Started: {{TIMESTAMP}})

🟢 **{{TIMESTAMP}}** - Initialized project with SpecMap 3.3.2
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
1. Add timestamped entry for what you completed
2. Add 2-4 bullet points with specifics
3. Update the Cold Start Briefing for the next action
4. Update Last Known Good State
5. Update Resume Confidence
6. Save IMMEDIATELY
```
