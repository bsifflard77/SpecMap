# Clarify Command

Resolve ambiguities and open questions in a specification.

## Usage

```
/clarify [feature-id]
/clarify          # Uses most recent feature
```

## Process

1. **Scan** specification for ambiguities
2. **Identify** all `[NEEDS CLARIFICATION]` markers
3. **Categorize** questions by priority (P0-P3)
4. **Gather** answers through interactive Q&A
5. **Update** specification with resolved answers
6. **Rescore** affected RULEMAP sections

## Question Categories

| Priority | Description | Action |
|----------|-------------|--------|
| P0 | Blocking | Must resolve before planning |
| P1 | Important | Should resolve before planning |
| P2 | Nice-to-have | Can defer to implementation |
| P3 | Future | Document for later |

## Question Types

### Technical Questions
- Architecture decisions
- Technology choices
- Integration approaches
- Performance requirements

### Business Questions
- Priority decisions
- Scope boundaries
- Success criteria
- Timeline requirements

### UX Questions
- User flow preferences
- Visual design direction
- Accessibility requirements
- Error handling approach

## Question Format

```markdown
## [###-Q-XXX]: [Question Summary]

**Category**: Technical | Business | UX | Scope
**Priority**: P0 | P1 | P2 | P3
**Status**: Open
**Blocks**: [List of blocked items]

### Context
[Why this question arose]

### Question
[Clear, specific question]

### Options
1. [Option A]: [Pros/Cons]
2. [Option B]: [Pros/Cons]

### Answer
[To be filled when resolved]
```

## Clarification Session

Interactive session format:

```
Claude: I found 5 open questions in spec 001-F:

P0 (Blocking):
1. [001-Q-001]: What OAuth providers should we support?
2. [001-Q-002]: What's the session timeout policy?

P1 (Important):
3. [001-Q-003]: Should we support SSO?

Let's start with the blocking questions. For [001-Q-001], 
I've identified these common options:
- Google + GitHub (developer-focused)
- Google + Microsoft (enterprise-focused)
- All major providers (maximum compatibility)

Which approach fits your needs?
```

## Output

1. **Updated spec.md** - Clarifications integrated
2. **Clarification log** - Session documented
3. **Updated scores** - RULEMAP rescored
4. **progress.md** - Actions logged

## Completion Criteria

Clarification complete when:
- [ ] No `[NEEDS CLARIFICATION]` markers remain
- [ ] All P0/P1 questions resolved
- [ ] RULEMAP score ≥ 8.0
- [ ] Stakeholder approval obtained
