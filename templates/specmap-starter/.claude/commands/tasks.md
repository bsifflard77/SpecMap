---
description: Break down plan into TDD tasks
---

# /tasks

Convert implementation plan into actionable TDD tasks.

## Usage
`/tasks [feature-id]`

## Prerequisites
- Plan must be complete
- All milestones defined

## Process

1. **Read** plan.md
2. **Break down** each milestone into tasks
3. **Define** test-first approach for each
4. **Set** dependencies
5. **Create** tasks.md in feature folder
6. **Update** features.json with tasks
7. **Update** progress.md

## Task Format

Each task includes:
- ID: [FEATURE]-T-[NUM]
- Description
- Test criteria (TDD)
- Dependencies
- Acceptance criteria link
