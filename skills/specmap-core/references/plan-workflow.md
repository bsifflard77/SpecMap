# Plan Workflow

Transform approved specifications into actionable implementation plans.

## Prerequisites

- Specification RULEMAP score ≥ 8.0
- No open P0/P1 questions
- Stakeholder approval obtained

## Plan Template

```markdown
# Implementation Plan: [FEATURE NAME]

**Feature ID**: [###-F]
**Specification**: [Link to spec.md]
**Plan Version**: 1.0
**Created**: [DATE]
**Status**: Draft | Review | Approved

---

## Executive Summary

[2-3 sentences: What we're building, why, expected outcome]

---

## Technical Approach

### Architecture Overview
[High-level architecture description]

```
[ASCII diagram or description of component relationships]
```

### Technology Stack
| Layer | Technology | Rationale |
|-------|------------|-----------|
| Frontend | [Tech] | [Why] |
| Backend | [Tech] | [Why] |
| Database | [Tech] | [Why] |
| Infrastructure | [Tech] | [Why] |

---

## Technical Decisions

### [###-D-001]: [Decision Title]
**Status**: Proposed | Approved | Implemented
**Date**: [DATE]

**Context**: [Why this decision is needed]

**Options Considered**:
1. **[Option A]**: [Description]
   - Pros: [List]
   - Cons: [List]
2. **[Option B]**: [Description]
   - Pros: [List]
   - Cons: [List]

**Decision**: [Chosen option]

**Rationale**: [Why this choice]

**Consequences**: 
- [Positive consequence]
- [Trade-off accepted]

---

### [###-D-002]: [Next Decision]
[Same format]

---

## Implementation Phases

### Phase 1: [Phase Name]
**Duration**: [Estimate]
**Goal**: [What this phase achieves]

**Deliverables**:
- [Deliverable 1]
- [Deliverable 2]

**Requirements Covered**:
- [###-R-001]
- [###-R-002]

**Exit Criteria**:
- [ ] [Criterion 1]
- [ ] [Criterion 2]

---

### Phase 2: [Phase Name]
[Same format]

---

## Milestones

### [###-M-001]: [Milestone Name]
**Target Date**: [DATE]
**Owner**: [Role/Person]

**Deliverables**:
- [What's delivered]

**Success Criteria**:
- [How we know it's done]

**Dependencies**:
- [What must be complete first]

---

## Risk Assessment

### [###-I-001]: [Risk Title]
**Probability**: High | Medium | Low
**Impact**: High | Medium | Low
**Status**: Open | Mitigated | Accepted

**Description**: [What could go wrong]

**Mitigation**: [How we prevent/handle it]

**Contingency**: [Plan B if it happens]

---

## Resource Requirements

### Team
| Role | Allocation | Responsibilities |
|------|------------|------------------|
| [Role] | [%] | [What they do] |

### Infrastructure
- [Resource 1]: [Purpose]
- [Resource 2]: [Purpose]

### External Dependencies
- [Dependency 1]: [Owner, timeline]

---

## Timeline

```
Week 1-2: Phase 1 - [Description]
  └─ [###-M-001]: [Milestone]
Week 3-4: Phase 2 - [Description]
  └─ [###-M-002]: [Milestone]
Week 5:   Testing & Documentation
  └─ [###-M-003]: Release Ready
```

---

## Success Metrics

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| [Metric 1] | [Target] | [How measured] |
| [Metric 2] | [Target] | [How measured] |

---

## Open Items

- [ ] [###-Q-XXX]: [Question]
- [ ] [###-I-XXX]: [Issue to resolve]

---

## Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Product Owner | | | Pending |
| Tech Lead | | | Pending |
| Stakeholder | | | Pending |
```

## Decision Framework

### When to Document a Decision

Create `[###-D-XXX]` for:
- Technology choices
- Architecture patterns
- Third-party integrations
- Performance trade-offs
- Security approaches
- API design choices

### Decision Template (Compact)

```markdown
### [###-D-XXX]: [Title]
**Status**: Approved
**Context**: [1-2 sentences]
**Decision**: [What we chose]
**Rationale**: [Why]
**Consequences**: [What this means]
```

## Estimation Guidelines

### Effort Estimation

| Complexity | Description | Typical Duration |
|------------|-------------|------------------|
| XS | Trivial change, well-understood | < 2 hours |
| S | Simple, clear requirements | 2-8 hours |
| M | Moderate complexity | 1-3 days |
| L | Complex, some unknowns | 3-5 days |
| XL | Very complex, significant unknowns | 1-2 weeks |

### Risk Factors

Add buffer for:
- New technology: +25-50%
- External dependencies: +25%
- Unclear requirements: +50%
- Integration complexity: +25%

## Plan Review Checklist

Before marking plan as "Ready for Tasks":

- [ ] All technical decisions documented
- [ ] Milestones defined with dates
- [ ] Risks identified and mitigated
- [ ] Resource requirements clear
- [ ] Dependencies mapped
- [ ] Success metrics defined
- [ ] Stakeholder approval obtained
