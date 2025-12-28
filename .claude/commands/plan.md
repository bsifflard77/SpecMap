# Plan Command

Generate an implementation plan from an approved specification.

## Usage

```
/plan [feature-id]
/plan          # Uses most recent feature with approved spec
```

## Prerequisites

- Specification RULEMAP score ≥ 8.0
- No open P0/P1 questions
- Stakeholder approval obtained

## Process

1. **Analyze** approved specification
2. **Identify** technical approach and architecture
3. **Document** architectural decisions ([###-D-XXX])
4. **Define** implementation phases
5. **Set** milestones ([###-M-XXX])
6. **Estimate** effort and timeline
7. **Identify** risks and mitigation

## Plan Structure

### Technical Approach
- Architecture overview
- Technology stack decisions
- Integration strategy

### Decisions ([###-D-XXX])
```markdown
### [###-D-001]: [Decision Title]
**Status**: Proposed | Approved
**Context**: [Why needed]
**Options**: 
1. [Option A]
2. [Option B]
**Decision**: [Chosen option]
**Rationale**: [Why]
**Consequences**: [Impact]
```

### Implementation Phases
```markdown
### Phase 1: [Name]
**Duration**: [Estimate]
**Goal**: [What this achieves]
**Deliverables**: [List]
**Requirements Covered**: [###-R-XXX]
```

### Milestones ([###-M-XXX])
```markdown
### [###-M-001]: [Milestone Name]
**Target Date**: [DATE]
**Deliverables**: [What's complete]
**Success Criteria**: [How to verify]
```

### Risk Assessment
```markdown
### [###-I-001]: [Risk Title]
**Probability**: High | Medium | Low
**Impact**: High | Medium | Low
**Mitigation**: [Prevention strategy]
**Contingency**: [Plan B]
```

## Estimation Guidelines

| Size | Description | Duration |
|------|-------------|----------|
| XS | Trivial | < 2 hours |
| S | Simple | 2-8 hours |
| M | Moderate | 1-3 days |
| L | Complex | 3-5 days |
| XL | Very complex | 1-2 weeks |

Add buffer for:
- New technology: +25-50%
- External dependencies: +25%
- Unclear requirements: +50%

## Output Files

1. `01-specifications/[###]-[feature]/plan.md` - Full plan
2. `features.json` - Status updated to "Planning"
3. `progress.md` - Actions logged

## Plan Review Checklist

Before proceeding to tasks:
- [ ] All technical decisions documented
- [ ] Milestones defined with dates
- [ ] Risks identified and mitigated
- [ ] Resource requirements clear
- [ ] Dependencies mapped
- [ ] Stakeholder approval obtained

## Example

```
/plan 001-user-authentication
```

Generates: `01-specifications/001-user-authentication/plan.md`
