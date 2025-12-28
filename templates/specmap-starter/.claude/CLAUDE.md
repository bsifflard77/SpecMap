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
