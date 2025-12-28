# Tasks Command

Break down an implementation plan into TDD-ready tasks.

## Usage

```
/tasks [feature-id]
/tasks          # Uses most recent feature with approved plan
```

## Prerequisites

- Approved implementation plan
- All technical decisions made
- Milestones defined

## Process

1. **Analyze** approved plan
2. **Map** requirements to tasks
3. **Generate** task IDs ([###-T-XXX])
4. **Size** each task (XS/S/M/L)
5. **Identify** dependencies
6. **Group** for parallel execution
7. **Structure** for TDD workflow

## Task Structure

```markdown
## [###-T-XXX]: [Task Title]

**Implements**: [###-R-XXX]
**Effort**: XS | S | M | L
**Depends On**: [###-T-YYY] or None
**Blocks**: [###-T-ZZZ]
**File**: `src/path/to/file.ts`

### Description
[What this task accomplishes]

### Acceptance Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]

### TDD Steps
1. **RED**: Write failing test for [behavior]
2. **GREEN**: Implement minimum to pass
3. **REFACTOR**: Clean up if needed
```

## Task Sizing

| Size | Duration | Characteristics |
|------|----------|-----------------|
| XS | < 1 hour | Config, simple fix |
| S | 1-4 hours | Clear implementation |
| M | 4-8 hours | Standard feature |
| L | 1-2 days | Complex feature |
| XL | > 2 days | **Break down further!** |

## Parallel Execution Groups

Group independent tasks:

```markdown
### Parallel Group 1: Foundation
[###-T-001], [###-T-002], [###-T-003]
- No shared dependencies
- Different files
- Can merge independently

### Parallel Group 2: Core Logic
[###-T-004], [###-T-005]
- Requires: Group 1 complete
```

## Dependency Mapping

```
[###-T-001] ──┐
             ├──→ [###-T-003] ──→ [###-T-005]
[###-T-002] ──┘                        │
                                       ▼
[###-T-004] ─────────────────────→ [###-T-006]
```

## Test Strategy

Include test tasks:

```markdown
### Unit Tests
- [###-T-010]: Tests for AuthService
- [###-T-011]: Tests for UserRepository

### Integration Tests
- [###-T-020]: API integration tests
- [###-T-021]: Database integration tests

### E2E Tests
- [###-T-030]: Login flow E2E
- [###-T-031]: Registration flow E2E
```

## Output Files

1. `01-specifications/[###]-[feature]/tasks.md` - Task breakdown
2. `01-specifications/[###]-[feature]/TRACKING.md` - Progress tracker
3. `features.json` - Status updated to "Implementation"
4. `progress.md` - Actions logged

## Task Checklist

Before starting implementation:
- [ ] All requirements mapped to tasks
- [ ] No task > 2 days (break down XL)
- [ ] Dependencies identified
- [ ] Parallel groups defined
- [ ] Test tasks included
- [ ] Files identified for each task

## Example

```
/tasks 001-user-authentication
```

Generates: `01-specifications/001-user-authentication/tasks.md`
