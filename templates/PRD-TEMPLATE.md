# PRD: [Feature Name]

**Created**: [YYYY-MM-DD HH:MM:SS]
**Status**: Draft | Approved | In Progress | Complete
**Scope**: Minimal | Standard | Full
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

---

<!--
Add more stories as needed. Remember:

STATUS EMOJIS:
- ⏳ Pending (not started)
- 🔄 In Progress (current story)
- ✅ Complete (all criteria [x])
- ❌ Blocked (cannot proceed)
- ⏸️ Paused (user requested stop)

CRITERION RULES:
- Every criterion MUST be specific, verifiable, atomic
- Always include "Typecheck passes" and "Tests pass"
- For UI stories, add "Verify changes work in browser"

STORY ORDER (by dependency):
1. Schema/Database changes (migrations)
2. Types/Interfaces
3. Server actions / Backend logic
4. Hooks / State management
5. UI components
6. Integration / Polish
-->

---

## Decisions Log

| ID | Decision | Rationale | Date |
|----|----------|-----------|------|
| D-001 | [What was decided] | [Why] | [YYYY-MM-DD] |

---

## Assumptions

| Assumption | Confidence | Validated |
|------------|------------|-----------|
| [Assumption] | High/Med/Low | Yes/No |
