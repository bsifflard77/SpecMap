---
name: specmap-core
description: "Specification-driven development system using RULEMAP framework for AI-assisted projects. Use when: (1) Initializing new development projects, (2) Creating PRDs or feature specifications, (3) Breaking down requirements into tasks, (4) Tracking project progress with IDs, (5) Managing quality with RULEMAP scoring (≥8.0 threshold), (6) Resuming work from any project state. Triggers on: 'specmap', 'specification', 'PRD', 'product requirements', 'task breakdown', 'project tracking', 'RULEMAP', 'feature specification', 'requirements document'."
---

# SpecMap Core

Specification-driven development system that transforms product concepts into actionable, trackable implementation plans using the RULEMAP framework.

## Quick Start

### Initialize Project
Create three core files in project root:
1. `SPECMAP.md` - Rules and conventions
2. `features.json` - Feature intent tracking  
3. `progress.md` - Session heartbeat (update after every action)

### Core Workflow
```
specify → clarify → plan → tasks → implement → track
```

## RULEMAP Framework

Every specification scores against 7 elements (target ≥8.0):

| Element | Focus | Key Questions |
|---------|-------|---------------|
| **R** - Role | Authority & responsibility | Who owns this? What decisions can they make? |
| **U** - Understanding | Objectives & success | What problem? How do we know it's solved? |
| **L** - Logic | Structure & flow | How does it work? What's the sequence? |
| **E** - Elements | Specifications & constraints | What exactly must it do/not do? |
| **M** - Mood | Experience & aesthetics | How should it feel? What's the tone? |
| **A** - Audience | Stakeholders & users | Who uses this? What do they need? |
| **P** - Performance | Metrics & success criteria | How do we measure success? |

## Tracking ID System

All items use hierarchical IDs for clear communication:

```
[FEATURE]-[TYPE]-[NUMBER]
Example: 001-T-042 = Feature 001, Task 42
```

### Type Codes
| Code | Type | Example |
|------|------|---------|
| F | Feature | `001-F` |
| R | Requirement | `001-R-015` |
| T | Task | `001-T-042` |
| Q | Question | `001-Q-007` |
| D | Decision | `001-D-003` |
| I | Issue | `001-I-001` |
| A | Acceptance | `001-A-012` |
| M | Milestone | `001-M-002` |

### Status Suffixes (Optional)
`-O` Open, `-IP` In Progress, `-B` Blocked, `-C` Complete

## Workflows

### 1. Specify (Create PRD)
See [references/specify-workflow.md](references/specify-workflow.md) for complete template.

Key steps:
1. Gather product concept from user
2. Structure using RULEMAP elements
3. Generate tracking IDs for requirements
4. Score each section (0-10)
5. Iterate until overall ≥8.0

### 2. Clarify (Resolve Ambiguity)
See [references/clarify-workflow.md](references/clarify-workflow.md) for patterns.

Key steps:
1. Identify `[NEEDS CLARIFICATION]` markers
2. Generate focused questions
3. Update spec with answers
4. Rescore affected sections

### 3. Plan (Implementation Strategy)
See [references/plan-workflow.md](references/plan-workflow.md) for template.

Key steps:
1. Analyze technical requirements
2. Make architectural decisions (001-D-XXX)
3. Define milestones (001-M-XXX)
4. Estimate effort and dependencies

### 4. Tasks (TDD Breakdown)
See [references/tasks-workflow.md](references/tasks-workflow.md) for patterns.

Key steps:
1. Break requirements into tasks (001-T-XXX)
2. Identify parallel execution groups
3. Map dependencies
4. Structure for TDD (test → implement → refactor)

### 5. Track (Progress Updates)
Update `progress.md` after EVERY action:

```markdown
## Session: 2025-12-23

### Completed
- ✅ 001-T-042: Implement password validation
- ✅ 001-T-043: Add unit tests

### In Progress
- 🔄 001-T-044: OAuth integration

### Blocked
- ⛔ 001-T-050: Waiting on 001-D-005

### Next
- 001-T-045: Session management
```

## Quality Gates

| Gate | Criteria | Action if Fail |
|------|----------|----------------|
| Spec Ready | RULEMAP ≥8.0, no `[NEEDS CLARIFICATION]` | Return to clarify |
| Plan Ready | All decisions made, milestones defined | Review with stakeholder |
| Tasks Ready | All requirements covered, dependencies mapped | Refine breakdown |
| Implementation Ready | Tests written, acceptance criteria clear | Clarify requirements |

## File Structure

```
project/
├── SPECMAP.md              # Project rules
├── features.json           # Feature registry
├── progress.md             # Session heartbeat
└── 01-specifications/
    └── [###-feature-name]/
        ├── spec.md         # RULEMAP specification
        ├── plan.md         # Implementation plan
        ├── tasks.md        # Task breakdown
        └── TRACKING.md     # Feature progress
```

## Integration

For document generation, see skill: `specmap-documents`
For agent orchestration, see skill: `specmap-agents`

## Scripts

- `scripts/init_project.py` - Initialize new SpecMap project
- `scripts/calculate_score.py` - Calculate RULEMAP score
- `scripts/generate_tracking.py` - Generate tracking dashboard
