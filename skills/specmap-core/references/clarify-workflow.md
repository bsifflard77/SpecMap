# Clarify Workflow

Systematic process for resolving ambiguities in specifications.

## When to Clarify

1. RULEMAP score < 8.0
2. `[NEEDS CLARIFICATION]` markers present
3. Open questions blocking progress
4. Stakeholder feedback received

## Clarification Process

### Step 1: Identify Open Items

Scan specification for:
```
[NEEDS CLARIFICATION: ...]
[TODO: ...]
[TBD]
[?]
```

### Step 2: Categorize Questions

| Category | Priority | Example |
|----------|----------|---------|
| Blocking | P0 | "What authentication method?" |
| Important | P1 | "What's the error message format?" |
| Nice-to-have | P2 | "Preferred color scheme?" |
| Deferrable | P3 | "Future enhancement scope?" |

### Step 3: Generate Questions

Format each question:

```markdown
## Question: [###-Q-XXX]

**Category**: [Technical/Business/UX/Scope]
**Priority**: P0/P1/P2/P3
**Status**: Open
**Blocks**: [List of blocked items]

### Context
[Why this matters, what led to the question]

### Question
[Clear, specific question]

### Options Considered
1. [Option A]: [Pros/cons]
2. [Option B]: [Pros/cons]

### Recommendation
[If applicable, suggested answer with rationale]

### Answer
[To be filled when resolved]
```

### Step 4: Gather Answers

Sources:
- Direct user input
- Stakeholder consultation
- Technical research
- Competitive analysis
- Domain expertise

### Step 5: Update Specification

For each resolved question:

1. **Replace marker** with answer
2. **Update tracking**:
   ```markdown
   - [###-Q-XXX]: Resolved - [Brief answer]
   ```
3. **Rescore section** affected by answer
4. **Log in progress.md**:
   ```markdown
   - ✅ Resolved [###-Q-XXX]: [Question summary]
   ```

## Question Templates

### Technical Questions

```markdown
## [###-Q-XXX]: [Technology/Architecture Decision]

**Context**: [Current technical situation]
**Constraints**: [What limits our choices]

**Question**: Should we use [Option A] or [Option B] for [capability]?

**Analysis**:
| Factor | Option A | Option B |
|--------|----------|----------|
| Performance | | |
| Maintainability | | |
| Cost | | |
| Team expertise | | |

**Recommendation**: [Option] because [rationale]
```

### Business Questions

```markdown
## [###-Q-XXX]: [Business Rule/Priority]

**Context**: [Business situation]
**Stakeholders**: [Who needs to decide]

**Question**: [Specific business question]

**Impact Analysis**:
- Option A: [Business impact]
- Option B: [Business impact]

**Recommendation**: [If applicable]
```

### Scope Questions

```markdown
## [###-Q-XXX]: [Feature Scope]

**Context**: [Why scope is unclear]
**Related Requirements**: [###-R-XXX, ###-R-YYY]

**Question**: Should [capability] be included in this release?

**Scope Analysis**:
- In Scope: [What's clearly included]
- Out of Scope: [What's clearly excluded]
- Gray Area: [This question]

**Recommendation**: [Include/Exclude] because [rationale]
```

## Session Format

When running a clarification session:

```markdown
# Clarification Session: [DATE]

## Feature: [###-F] - [Feature Name]

## Questions to Resolve
1. [###-Q-001]: [Summary]
2. [###-Q-002]: [Summary]

## Session Notes

### [###-Q-001]
**Asked**: [Question]
**Discussed**: [Key points from discussion]
**Decided**: [Final answer]
**Rationale**: [Why this decision]
**Action Items**: [Any follow-up needed]

### [###-Q-002]
[Same format]

## Updated Scores
- [Section]: [Old] → [New]

## Remaining Open Questions
- [###-Q-003]: [Still needs answer]
```

## Clarification Checklist

Before marking specification as "Ready for Planning":

- [ ] No `[NEEDS CLARIFICATION]` markers remain
- [ ] All P0/P1 questions resolved
- [ ] RULEMAP score ≥ 8.0
- [ ] Stakeholder approval obtained
- [ ] All acceptance criteria are testable
- [ ] No conflicting requirements
- [ ] Technical feasibility confirmed
