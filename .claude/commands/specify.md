# Specify Command

Create a RULEMAP-structured specification for a product feature.

## Usage

```
/specify [feature concept or description]
```

## Process

1. **Analyze** the feature concept
2. **Create** specification folder: `01-specifications/[###]-[feature-name]/`
3. **Generate** spec.md using RULEMAP framework
4. **Score** each section (0-10)
5. **Iterate** until overall score ≥ 8.0

## RULEMAP Structure

### R - Role & Authority
- Who owns this feature?
- What decisions can they make?
- Who are the stakeholders?

### U - Understanding & Objectives
- What problem does this solve?
- What are the user stories?
- How do we measure success?

### L - Logic & Structure
- How does the feature work?
- What's the user journey?
- What are the dependencies?

### E - Elements & Specifications
- What are the functional requirements?
- What are the technical constraints?
- What are the acceptance criteria?

### M - Mood & Experience
- How should users feel?
- What's the visual/interaction style?
- What's the accessibility approach?

### A - Audience & Stakeholders
- Who are the primary users?
- What are their pain points?
- Who else is affected?

### P - Performance & Metrics
- What are the success KPIs?
- What are the technical performance targets?
- What are the milestones?

## Tracking IDs

Generate these IDs during specification:

- `[###]-F` - Feature ID
- `[###]-R-[###]` - Requirements
- `[###]-A-[###]` - Acceptance criteria
- `[###]-Q-[###]` - Open questions

## Quality Threshold

Do not proceed to planning until:
- Overall RULEMAP score ≥ 8.0
- No `[NEEDS CLARIFICATION]` markers remain
- All P0/P1 questions resolved

## Output Files

1. `01-specifications/[###]-[feature-name]/spec.md` - Full specification
2. `features.json` - Updated with new feature
3. `progress.md` - Updated with action log

## Example

```
/specify user authentication system with OAuth and email/password login
```

Creates: `01-specifications/001-user-authentication/spec.md`
