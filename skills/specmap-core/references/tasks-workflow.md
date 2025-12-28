# Tasks Workflow

Break implementation plans into actionable, TDD-ready task lists.

## Prerequisites

- Approved implementation plan
- All technical decisions made
- Milestones defined

## Task Breakdown Template

```markdown
# Task Breakdown: [FEATURE NAME]

**Feature ID**: [###-F]
**Plan**: [Link to plan.md]
**Created**: [DATE]
**Total Tasks**: [Count]
**Estimated Duration**: [Days/Weeks]

---

## Summary

| Phase | Tasks | Estimated Effort |
|-------|-------|------------------|
| Phase 1: [Name] | [X] | [Y days] |
| Phase 2: [Name] | [X] | [Y days] |
| Total | [X] | [Y days] |

---

## Relevant Files

Files that will be created or modified:

```
src/
├── components/
│   └── NewFeature.tsx       # New - Main component
├── services/
│   └── feature-service.ts   # New - Business logic
├── api/
│   └── feature-api.ts       # New - API layer
└── types/
    └── feature-types.ts     # New - Type definitions
```

---

## Phase 1: [Phase Name]

### Parallel Group 1 (Can run simultaneously)

#### [###-T-001]: [Task Title]
**Implements**: [###-R-XXX]
**Effort**: S | M | L
**Dependencies**: None
**File**: `src/path/to/file.ts`

**Description**: [What this task accomplishes]

**Acceptance Criteria**:
- [ ] [Criterion 1]
- [ ] [Criterion 2]

**TDD Steps**:
1. Write test: [Test description]
2. Implement: [Implementation approach]
3. Refactor: [If applicable]

---

#### [###-T-002]: [Task Title]
[Same format]

---

### Parallel Group 2 (Depends on Group 1)

#### [###-T-003]: [Task Title]
**Implements**: [###-R-XXX]
**Effort**: M
**Dependencies**: [###-T-001], [###-T-002]
**File**: `src/path/to/file.ts`

[Same format]

---

## Phase 2: [Phase Name]

[Same structure]

---

## Dependency Graph

```
[###-T-001] ──┐
             ├──→ [###-T-003] ──→ [###-T-005]
[###-T-002] ──┘                        │
                                       ▼
[###-T-004] ─────────────────────→ [###-T-006]
```

---

## Test Strategy

### Unit Tests
- [###-T-XXX]: Tests for [component]
- [###-T-XXX]: Tests for [service]

### Integration Tests
- [###-T-XXX]: API integration tests
- [###-T-XXX]: Database integration tests

### E2E Tests
- [###-T-XXX]: User flow tests

---

## Definition of Done

Each task is complete when:
- [ ] Code implemented
- [ ] Tests passing
- [ ] Code reviewed
- [ ] Documentation updated
- [ ] Acceptance criteria verified
```

## Task Creation Guidelines

### Good Task Characteristics

1. **Atomic**: One clear deliverable
2. **Testable**: Clear acceptance criteria
3. **Sized Right**: 2-8 hours typical
4. **Independent**: Minimal dependencies
5. **Valuable**: Delivers user value or unblocks others

### Task Sizing

| Size | Description | Typical Duration |
|------|-------------|------------------|
| XS | Config change, simple fix | < 1 hour |
| S | Simple implementation | 1-4 hours |
| M | Standard feature | 4-8 hours |
| L | Complex feature | 1-2 days |
| XL | Very complex, break down further | > 2 days |

**Rule**: If XL, break into smaller tasks.

### Task Template (Compact)

```markdown
#### [###-T-XXX]: [Title]
**Implements**: [###-R-XXX] | **Effort**: [S/M/L]
**Depends**: [###-T-YYY] | **File**: `path/to/file.ts`
- [ ] [Acceptance criterion 1]
- [ ] [Acceptance criterion 2]
```

## TDD Integration

### Task Structure for TDD

Each implementation task should follow:

```markdown
#### [###-T-XXX]: Implement [Feature]

**TDD Workflow**:
1. **RED** - Write failing test
   - Test file: `tests/feature.test.ts`
   - Test case: [What to test]
   
2. **GREEN** - Implement minimum to pass
   - Implementation file: `src/feature.ts`
   - Approach: [How to implement]
   
3. **REFACTOR** - Clean up
   - [ ] Remove duplication
   - [ ] Improve naming
   - [ ] Extract abstractions if needed
```

### Test Task Template

```markdown
#### [###-T-XXX]: Tests for [Component]
**Type**: Unit | Integration | E2E
**File**: `tests/[component].test.ts`

**Test Cases**:
- [ ] [Test case 1]
- [ ] [Test case 2]
- [ ] [Edge case 1]
- [ ] [Error handling]
```

## Parallel Execution

### Identifying Parallel Groups

Tasks can run in parallel when they:
- Have no shared dependencies
- Modify different files
- Don't share database state
- Can be integrated later

### Marking Parallel Groups

```markdown
### Parallel Group 1: Foundation
[###-T-001], [###-T-002], [###-T-003]
Can run simultaneously

### Parallel Group 2: Core Logic
[###-T-004], [###-T-005]
Requires: Parallel Group 1 complete

### Sequential: Integration
[###-T-006] → [###-T-007] → [###-T-008]
Must run in order
```

## Progress Tracking

### Task Status Updates

Update in `progress.md` after each action:

```markdown
## [DATE]

### Completed
- ✅ [###-T-001]: [Task name] - [Duration]
- ✅ [###-T-002]: [Task name] - [Duration]

### In Progress
- 🔄 [###-T-003]: [Task name] - [Progress %]

### Blocked
- ⛔ [###-T-004]: Waiting on [###-D-XXX]

### Up Next
- ⏳ [###-T-005]: [Task name]
```

### Task Completion Checklist

Before marking task complete:

- [ ] Implementation done
- [ ] Tests written and passing
- [ ] Code reviewed (if required)
- [ ] Documentation updated
- [ ] All acceptance criteria met
- [ ] No regressions introduced
- [ ] PR merged (if applicable)
