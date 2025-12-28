# Specify Workflow

Complete workflow for creating RULEMAP-enhanced specifications.

## PRD Template

```markdown
# Feature Specification: [FEATURE NAME]

**Feature ID**: [###-F]
**Created**: [DATE]
**Status**: Draft | Review | Approved
**RULEMAP Score**: [X.X/10.0]

---

## R - ROLE & AUTHORITY

### Product Owner
**Primary Identity**: [Role with specific expertise]
**Authority Boundaries**: [What decisions they can make]
**Stakeholder Representation**: [Who they advocate for]

### Technical Authority
**Development Oversight**: [Technical decision rights]
**Architecture Influence**: [Design authority level]

**Section Score**: [0-10]

---

## U - UNDERSTANDING & OBJECTIVES

### Problem Statement
**Core Problem**: [What needs solving - be specific]
**Impact Analysis**: [Cost of not solving - quantify if possible]
**Root Cause**: [Why this problem exists]
**Urgency Level**: [Critical/High/Medium/Low with justification]

### User Stories
```yaml
[###-R-001]:
  as_a: "[Specific user type]"
  i_want: "[Concrete action]"
  so_that: "[Measurable benefit]"
  acceptance_criteria:
    - "[###-A-001]: [Testable condition]"
    - "[###-A-002]: [Testable condition]"
```

### Business Objectives
- **Primary Goal**: [Main measurable outcome]
- **Secondary Goals**: [Supporting outcomes]
- **Success Metrics**: [Specific KPIs]

**Section Score**: [0-10]

---

## L - LOGIC & STRUCTURE

### Feature Architecture
**System Integration**: [How feature fits existing system]
**Component Breakdown**: 
1. [Component 1]: [Purpose]
2. [Component 2]: [Purpose]

**Data Flow**: [How information moves]
**User Journey**: [Step-by-step interaction]

### Implementation Sequence
```yaml
Phase_1:
  name: "[Phase name]"
  objectives: ["Goal 1", "Goal 2"]
  deliverables: ["Deliverable 1"]
  duration: "[Estimate]"
```

### Dependencies
**Upstream**: [Required inputs/systems]
**Downstream**: [Affected systems]
**Risks**: [Potential issues with mitigation]

**Section Score**: [0-10]

---

## E - ELEMENTS & SPECIFICATIONS

### Functional Requirements
- **[###-R-001]**: System MUST [capability]
- **[###-R-002]**: System MUST [capability]
- **[###-R-003]**: System SHOULD [capability]

### Technical Constraints
- **Platform**: [Technology requirements]
- **Performance**: [Speed/scale requirements]
- **Security**: [Compliance needs]
- **Integration**: [External system requirements]

### Acceptance Criteria
```yaml
[###-A-001]:
  scenario: "[Test scenario]"
  given: "[Initial condition]"
  when: "[User action]"
  then: "[Expected outcome]"
```

**Section Score**: [0-10]

---

## M - MOOD & EXPERIENCE

### User Experience Goals
**Emotional Target**: [How users should feel]
**Interaction Style**: [Formal/casual/friendly/professional]
**Visual Aesthetics**: [Look and feel]

### Accessibility
- [Accessibility requirement 1]
- [Accessibility requirement 2]

**Section Score**: [0-10]

---

## A - AUDIENCE & STAKEHOLDERS

### Primary Users
```yaml
Segment_1:
  demographics: "[Age, role, experience]"
  pain_points: "[Current problems]"
  success_definition: "[What they want to achieve]"
```

### Stakeholder Matrix
| Stakeholder | Interest | Influence | Engagement Strategy |
|-------------|----------|-----------|---------------------|
| [Role] | High/Med/Low | High/Med/Low | [How to engage] |

**Section Score**: [0-10]

---

## P - PERFORMANCE & METRICS

### Business KPIs
- **Primary**: [Main success measure with target]
- **Secondary**: [Supporting measures]

### Technical Performance
- **Response Time**: [Target, e.g., <200ms]
- **Throughput**: [Target, e.g., 1000 req/sec]
- **Availability**: [Target, e.g., 99.9%]

### Timeline
```yaml
[###-M-001]:
  name: "[Milestone name]"
  date: "[Target date]"
  deliverable: "[What's complete]"
  criteria: "[How to verify]"
```

**Section Score**: [0-10]

---

## Open Questions

- **[###-Q-001]**: [Question needing answer]
  - Status: Open | Answered
  - Blocks: [What it blocks]
  - Priority: High/Medium/Low

---

## RULEMAP Score Summary

| Element | Score | Notes |
|---------|-------|-------|
| R - Role | [0-10] | |
| U - Understanding | [0-10] | |
| L - Logic | [0-10] | |
| E - Elements | [0-10] | |
| M - Mood | [0-10] | |
| A - Audience | [0-10] | |
| P - Performance | [0-10] | |
| **OVERALL** | **[X.X]** | |

**Status**: [Ready for Planning / Needs Clarification / Needs Review]
```

## Scoring Rubric

### Score 9-10: Exceptional
- Complete, specific, measurable
- No ambiguity
- Clear acceptance criteria
- Stakeholder-validated

### Score 7-8: Good
- Mostly complete
- Minor clarifications needed
- Acceptance criteria present
- Some stakeholder input

### Score 5-6: Acceptable
- Basic coverage
- Several `[NEEDS CLARIFICATION]` markers
- Acceptance criteria incomplete
- Needs stakeholder review

### Score 3-4: Needs Work
- Major gaps
- Many ambiguities
- Missing acceptance criteria
- No stakeholder input

### Score 0-2: Insufficient
- Framework only
- Placeholder content
- Cannot proceed

## Clarification Markers

Use `[NEEDS CLARIFICATION: specific question]` for:
- Ambiguous requirements
- Missing stakeholder input
- Technical unknowns
- Scope questions
