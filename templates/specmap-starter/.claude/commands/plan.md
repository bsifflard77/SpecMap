---
description: Generate implementation plan for a feature
---

# /plan

Create a detailed implementation plan for a clarified specification.

## Usage
`/plan [feature-id]`

## Prerequisites
- Specification must have RULEMAP ≥ 8.0
- No [NEEDS CLARIFICATION] markers

## Process

1. **Verify** spec is ready (quality gate)
2. **Analyze** technical requirements
3. **Define** milestones
4. **Identify** dependencies
5. **Create** plan.md in feature folder
6. **Update** features.json with milestones
7. **Update** progress.md

## Plan Structure

- Milestones with clear deliverables
- Dependencies between components
- Technical decisions with rationale
- Risk considerations
