# /prd - Interactive PRD Development

You are helping the user create a PRD (Product Requirements Document) for a feature. Follow this process carefully.

## User Input: $ARGUMENTS

## Your Task

Guide the user through PRD development using this flow:

### Step 1: Receive & Analyze Input

The user has provided input above. Determine the input mode:

1. **Brain Dump**: User described their vision/idea in their own words
2. **Existing Work Reference**: User pointed to files/folders to review
3. **Hybrid**: User provided both context AND existing work references
4. **Minimal**: Just a feature name - you'll need to ask more questions

If user referenced existing code/files, READ THEM NOW before proceeding.

### Step 2: Summarize Understanding

Play back what you understood. Format:

```
Based on your description [and the existing code], here's what I understand:

**Feature**: [Name]
**Problem**: [What problem this solves]
**Solution**: [What we're building]
**Target Users**: [Who benefits]

[If you reviewed code:]
**From the codebase:**
- Tech stack: [what you found]
- Existing patterns: [relevant patterns]
- Integration points: [where this fits]
- Reusable components: [what we can leverage]

**What you've specified:**
✓ [Thing user made clear]
✓ [Thing user made clear]

Is this accurate? Anything to add or correct?
```

### Step 3: Targeted Clarification

Ask ONLY about gaps - things NOT covered by user input. Use this checklist:

**WHAT (Scope)**
- [ ] Problem clear?
- [ ] Features clear?
- [ ] What's NOT included clear?
- [ ] Priority clear?

**WHO (Users)**
- [ ] Target users clear?
- [ ] Who approves?

**HOW (Implementation)**
- [ ] Happy path clear?
- [ ] Error handling clear?
- [ ] Integration clear?
- [ ] Look/feel clear?

**WHAT IF (Edge Cases)**
- [ ] Edge cases covered?

For any unchecked items, ask:

```
I have a few questions about gaps I couldn't determine:

1. [Question]
   A. [Option]
   B. [Option]
   C. Other: [describe]

2. [Question]
   A. [Option]
   B. [Option]
```

User can respond: "1A, 2B" or provide freeform answers.

If user provided comprehensive input, you might say:
"I think I have everything I need. Ready to show scope options?"

### Step 4: Scope Options

Present 3 scope options:

```
Based on your requirements, here are scope options:

**Option A: Minimal ([X] stories)**
✓ [What's included]
✓ [What's included]
✗ [What's NOT included]

**Option B: Standard ([Y] stories)** ← Recommended
✓ [What's included]
✓ [What's included]
✓ [What's included]
✗ [What's NOT included]

**Option C: Full ([Z] stories)**
✓ Everything in B
✓ [Additional feature]
✓ [Additional feature]

Which scope? (A/B/C)
```

### Step 5: Draft PRD

After user selects scope, create PRD.md following this template:

```markdown
# PRD: [Feature Name]

**Created**: [YYYY-MM-DD HH:MM:SS]
**Status**: Draft
**Scope**: [Minimal/Standard/Full]
**Stories**: [X total] | **Complete**: 0 | **Remaining**: [X]

---

## Overview

**Problem**: [One sentence]
**Solution**: [One sentence]
**User**: [Who benefits]

---

## Scope Boundaries

**In Scope**:
- [Item]

**Out of Scope**:
- [Item]

---

## Stories

### US-001: [Title] ⏳
**Depends**: None
**Files**: `path/to/file`

- [ ] [Criterion - specific, verifiable]
- [ ] [Criterion]
- [ ] Typecheck passes
- [ ] Tests pass

---

[Continue for all stories...]

---

## Decisions Log

| ID | Decision | Rationale | Date |
|----|----------|-----------|------|

---

## Assumptions

| Assumption | Confidence | Validated |
|------------|------------|-----------|
```

**Story Order Rules:**
1. Schema/Database changes first
2. Types/Interfaces
3. Server/Backend logic
4. Hooks/State management
5. UI components
6. Integration/Polish

**Criterion Rules:**
- Every criterion must be specific, verifiable, atomic
- ALWAYS include "Typecheck passes" and "Tests pass"
- For UI stories, add "Verify changes work in browser"

### Step 6: Review Loop

Present the draft and ask:

```
Does this look right? You can:
- "approve" - Save and proceed
- "add [description]" - Add a story
- "remove US-XXX" - Remove a story
- "split US-XXX" - Break into smaller stories
- "change [description]" - Modify something
- "questions" - Ask me anything about the PRD
```

Loop until user says "approve".

### Step 7: Save & Push

When approved:

1. Save PRD.md to current directory
2. Create progress.md initialized for US-001:

```markdown
# Progress

**Feature**: [Feature Name]
**PRD**: PRD.md
**Started**: [YYYY-MM-DD HH:MM:SS]
**Last Updated**: [YYYY-MM-DD HH:MM:SS]
**Status**: Ready

---

## Cold Start Briefing

**Story**: US-001 - [First Story Title]
**Criterion**: [First criterion of US-001]
**State**: Not started - beginning fresh
**Next Action**: [First action to take]
**Files**: `[files from US-001]`
**Rollback**: None yet (first story)
**Last Push**: [YYYY-MM-DD HH:MM:SS] (PRD approved)

---

## Learnings

> None yet - first iteration.

---

## Iteration Log

> No iterations yet.

---

## Story Summary

| Story | Title | Status | Iterations |
|-------|-------|--------|------------|
[One row per story, all ⏳]
```

3. Git add and commit both files
4. Git push to remote

Output:

```
✅ PRD.md saved ([X] stories)
✅ progress.md initialized
✅ Committed: "feat: add PRD for [feature name]"
📤 Pushed to remote

To execute autonomously:
  .\scripts\ralph.ps1

To execute manually (story by story):
  "start US-001"
```

If push fails:
```
⚠️  Push failed (check network/auth) - committed locally

To push manually:
  git push origin HEAD
```

## Important Notes

- Track LOW-confidence assumptions and validate before approval
- Stories should be ordered by dependency
- Each criterion should be completable in ONE context window
- Always include typecheck and test criteria
- For UI work, include browser verification criterion
