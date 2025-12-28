# SpecMap Skills Guide

Complete guide to using SpecMap skills across AI platforms.

## Overview

SpecMap skills enable specification-driven development using the RULEMAP framework. The skills work across multiple AI platforms:

- **Claude Code / Claude.ai** - Native skills with slash commands
- **ChatGPT** - Custom GPTs with knowledge files
- **Google Gemini** - Gems with anchored files

## Core Concepts

### RULEMAP Framework

Every specification is structured around 7 elements:

| Element | Focus | Key Question |
|---------|-------|--------------|
| **R** - Role | Authority | Who owns this? |
| **U** - Understanding | Objectives | What problem does this solve? |
| **L** - Logic | Structure | How does it work? |
| **E** - Elements | Specifications | What exactly must it do? |
| **M** - Mood | Experience | How should it feel? |
| **A** - Audience | Stakeholders | Who uses this? |
| **P** - Performance | Metrics | How do we measure success? |

### Tracking ID System

All items use hierarchical IDs for clear communication:

```
[FEATURE]-[TYPE]-[NUMBER]
```

| Type Code | Meaning | Example |
|-----------|---------|---------|
| F | Feature | 001-F |
| R | Requirement | 001-R-015 |
| T | Task | 001-T-042 |
| Q | Question | 001-Q-007 |
| D | Decision | 001-D-003 |
| I | Issue | 001-I-001 |
| A | Acceptance | 001-A-012 |
| M | Milestone | 001-M-002 |

### Quality Threshold

All specifications must achieve RULEMAP score ≥ 8.0 before proceeding to planning.

## Workflow

```
specify → clarify → plan → tasks → implement → track
```

### 1. Specify

Create a RULEMAP-structured specification:

**Trigger phrases**: "create PRD", "write specification", "document requirements"

**Output**: `spec.md` with all RULEMAP sections, tracking IDs, and quality score

### 2. Clarify

Resolve ambiguities and open questions:

**Trigger phrases**: "clarify requirements", "resolve questions", "what's unclear"

**Output**: Updated `spec.md` with resolved `[NEEDS CLARIFICATION]` markers

### 3. Plan

Generate implementation plan with architecture decisions:

**Trigger phrases**: "create implementation plan", "how should we build this"

**Output**: `plan.md` with decisions (D-XXX), milestones (M-XXX), phases

### 4. Tasks

Break down into TDD-ready tasks:

**Trigger phrases**: "break down into tasks", "create task list", "what do we need to build"

**Output**: `tasks.md` with sized tasks (T-XXX), dependencies, parallel groups

### 5. Implement

Guide task-by-task implementation:

**Trigger phrases**: "start implementing", "work on task", "next task"

**Output**: Code, tests, and progress updates

### 6. Track

Update and monitor progress:

**Trigger phrases**: "update progress", "what's the status", "track completion"

**Output**: Updated `progress.md` and tracking reports

## Platform-Specific Usage

### Claude Code / Claude.ai

**Installation**:
```bash
# Copy skills to your project
cp -r skills/ your-project/.skills/

# Or copy to user skills directory
cp -r skills/* ~/.claude/skills/
```

**Usage**:
- Skills trigger automatically based on context
- Use slash commands for explicit actions:
  - `/specify [concept]`
  - `/clarify [feature-id]`
  - `/plan [feature-id]`
  - `/tasks [feature-id]`
  - `/track`

**Project Setup**:
1. Copy `CLAUDE.md` to your project root
2. Initialize with: "Initialize a SpecMap project for [name]"

### ChatGPT

**Installation**:
1. Go to ChatGPT → Explore GPTs → Create
2. Use definitions from `platforms/chatgpt/gpts/`
3. Upload knowledge files from `platforms/chatgpt/knowledge/`

**Available GPTs**:
- **SpecMap PRD Generator** - Create specifications
- **SpecMap Task Planner** - Break down requirements

**Usage**:
1. Select the appropriate GPT
2. Describe your feature or paste requirements
3. Follow the GPT's guided process

### Google Gemini

**Installation**:
1. Go to gemini.google.com → Gems
2. Create new Gem using definitions from `platforms/gemini/gems/`
3. Optionally anchor Google Drive files

**Available Gems**:
- **SpecMap Spec Writer** - Create RULEMAP specifications
- **SpecMap Task Planner** - Break down into tasks
- **SpecMap Dashboard** - Create tracking visualizations

**Usage**:
1. Select the Gem from your list
2. Start a conversation about your feature
3. The Gem follows its specialized instructions

## File Structure

After initialization, your project will have:

```
project/
├── SPECMAP.md              # Project rules
├── features.json           # Feature registry
├── progress.md             # Session heartbeat
├── CLAUDE.md               # Claude project instructions
└── 01-specifications/
    └── [###-feature-name]/
        ├── spec.md         # RULEMAP specification
        ├── plan.md         # Implementation plan
        ├── tasks.md        # Task breakdown
        └── TRACKING.md     # Feature progress
```

## Best Practices

### 1. Update Progress Immediately

After every action, update `progress.md`:

```markdown
### [DATE]

#### Completed
- ✅ [001-T-042]: Implemented password validation

#### In Progress
- 🔄 [001-T-043]: Adding unit tests

#### Blocked
- ⛔ [001-T-050]: Waiting on [001-D-005]
```

### 2. Use Tracking IDs Consistently

Always reference items by ID:
- ✅ "Working on 001-T-042"
- ❌ "Working on that password thing"

### 3. Iterate Until Quality Threshold

Don't proceed until:
- RULEMAP score ≥ 8.0
- No `[NEEDS CLARIFICATION]` markers
- All P0/P1 questions resolved

### 4. Size Tasks Appropriately

| Size | Duration | Action |
|------|----------|--------|
| XS | < 1 hour | ✅ Good |
| S | 1-4 hours | ✅ Good |
| M | 4-8 hours | ✅ Good |
| L | 1-2 days | ⚠️ Consider splitting |
| XL | > 2 days | ❌ Must split |

### 5. Document Decisions

Every significant choice gets a D-XXX ID:

```markdown
### [001-D-003]: Session Storage Choice

**Context**: Need to store user sessions
**Options**: Redis vs Database vs Memory
**Decision**: Redis
**Rationale**: Scalable, fast, supports TTL
**Consequences**: Additional infrastructure needed
```

## Troubleshooting

### Skill Not Triggering

**Claude**: Ensure skills are in the correct directory and contain valid `SKILL.md`

**ChatGPT**: Verify GPT instructions are complete and knowledge files are uploaded

**Gemini**: Check that Gem instructions are saved correctly

### Low RULEMAP Score

Review each section against the scoring rubric:
- 9-10: Complete, specific, measurable
- 7-8: Good but needs minor detail
- 5-6: Acceptable but gaps exist
- 3-4: Major revision needed
- 0-2: Section incomplete

Focus on the lowest-scoring sections first.

### Missing Context Between Sessions

Always check `progress.md` at session start:
1. Read last session's notes
2. Check current status of all items
3. Resume from documented state

The "save file philosophy" means any AI can resume from cold start using the core tracking files.

## Support

For issues or contributions:
- GitHub: [specmap repository]
- Documentation: specmap.ai
