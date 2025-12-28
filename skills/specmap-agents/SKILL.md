---
name: specmap-agents
description: "Multi-agent orchestration for SpecMap workflows. Coordinates specialized agents through the development lifecycle: PRD Generator, Task Planner, Development Guide, and QA Monitor. Use when: (1) Orchestrating complex development workflows, (2) Handing off between development phases, (3) Running parallel research or analysis, (4) Coordinating multiple specialists, (5) Managing agent context and memory. Triggers on: 'agent', 'orchestrate', 'coordinate', 'handoff', 'parallel work', 'multi-agent', 'specialist', 'PRD agent', 'task agent', 'QA agent', 'development guide'."
---

# SpecMap Agents

Multi-agent orchestration system for specification-driven development workflows.

## Agent Roles

### PRD Generator Agent
**Focus**: Requirements analysis and RULEMAP specification
**Persona**: Expert product manager with RULEMAP expertise

**Responsibilities**:
- Gather product concepts from stakeholders
- Structure requirements using RULEMAP framework
- Score specifications against quality threshold
- Identify clarification needs
- Iterate until score ≥ 8.0

**Inputs**: Product concept, stakeholder interviews
**Outputs**: Approved specification with RULEMAP score ≥ 8.0
**Handoff to**: Task Planner Agent

### Task Planner Agent
**Focus**: Implementation breakdown and dependency mapping
**Persona**: Expert technical architect

**Responsibilities**:
- Analyze approved specifications
- Make architectural decisions (###-D-XXX)
- Define milestones (###-M-XXX)
- Create task hierarchy (###-T-XXX)
- Estimate effort and identify dependencies

**Inputs**: Approved PRD, codebase context
**Outputs**: Implementation plan with task breakdown
**Handoff to**: Development Guide Agent

### Development Guide Agent
**Focus**: Implementation guidance and quality assurance
**Persona**: Expert software engineer and mentor

**Responsibilities**:
- Guide task-by-task implementation
- Provide code review feedback
- Ensure TDD workflow adherence
- Track progress in progress.md
- Flag blockers and issues

**Inputs**: Task list, technical context
**Outputs**: Completed implementation, quality feedback
**Handoff to**: QA Monitor Agent

### QA Monitor Agent
**Focus**: Quality validation and RULEMAP scoring
**Persona**: Expert QA engineer with systematic approach

**Responsibilities**:
- Validate all acceptance criteria
- Score final deliverables against RULEMAP
- Generate quality reports
- Verify deployment readiness
- Document lessons learned

**Inputs**: Completed implementation
**Outputs**: Validation report, deployment approval
**Handoff to**: Project completion or next iteration

## Orchestration Patterns

### Pattern 1: Sequential Handoff

Standard workflow through all phases:

```
User → PRD Generator → Task Planner → Dev Guide → QA Monitor → User
```

**Handoff protocol**:
```yaml
handoff:
  from: prd-generator
  to: task-planner
  trigger: "RULEMAP score ≥ 8.0 AND stakeholder approval"
  package:
    - specification (spec.md)
    - RULEMAP scores
    - stakeholder feedback
    - open questions (resolved)
```

### Pattern 2: Parallel Research

Multiple agents research simultaneously:

```
                    ┌─→ Research Agent 1 (Market) ─┐
User → Orchestrator ├─→ Research Agent 2 (Tech)   ─┼→ Synthesizer → PRD Generator
                    └─→ Research Agent 3 (Compete) ─┘
```

**Use when**: Initial discovery phase needs multiple perspectives

### Pattern 3: Iterative Refinement

Loop until quality threshold met:

```
Draft → Review → [Score < 8.0] → Improve → Draft
              → [Score ≥ 8.0] → Approve → Next Phase
```

**Use when**: Quality gates must be passed

### Pattern 4: Subagent Delegation

Main agent delegates specific tasks:

```python
# Main agent delegates to specialists
main_agent.delegate(
    to="database-specialist",
    task="Design schema for user authentication",
    context={"requirements": ["001-R-005", "001-R-006"]},
    await_result=True
)
```

**Use when**: Specialized expertise needed for specific tasks

## Agent Configuration

### Claude Code Subagents

```yaml
# .claude/agents/prd-generator.yaml
name: prd-generator
description: "Requirements analysis specialist"
model: claude-sonnet-4-20250514
temperature: 0.3

system_prompt: |
  You are the PRD Generator Agent for SpecMap.
  
  Your expertise:
  - RULEMAP framework (Role, Understanding, Logic, Elements, Mood, Audience, Performance)
  - Requirements elicitation and analysis
  - Stakeholder communication
  - Quality scoring (target ≥ 8.0)
  
  Your approach:
  - Ask clarifying questions before assuming
  - Structure all requirements using RULEMAP
  - Generate tracking IDs (###-R-###, ###-Q-###, etc.)
  - Score each section honestly
  - Iterate until quality threshold met
  
  Always update progress.md after significant actions.

tools:
  - file_read
  - file_write
  - web_search  # For competitive research
  
context_files:
  - SPECMAP.md
  - features.json
  - progress.md
```

### Agent Handoff Protocol

```markdown
## Handoff: PRD Generator → Task Planner

### Summary
Feature [###-F] specification complete and approved.

### Deliverables
- spec.md: Complete RULEMAP specification
- RULEMAP Score: 8.5/10
- Stakeholder Approval: ✅ [DATE]

### Key Points for Task Planner
1. Primary technical challenge: [Brief description]
2. Critical requirements: [###-R-001], [###-R-002]
3. Known constraints: [List]
4. Suggested architecture: [Overview]

### Open Items
- None blocking planning

### Context Files Updated
- progress.md: Reflects handoff
- features.json: Status updated to "Planning"
```

## Context Management

### Context Isolation

Each agent should have isolated context:

```python
# Subagent with isolated context
subagent = claude.create_subagent(
    name="database-specialist",
    context_isolation=True,  # Separate context window
    inherit_files=["SPECMAP.md", "spec.md"],  # Only essential files
    tools=["file_read", "bash"]  # Limited tools
)
```

### Context Compression

For long workflows, compress context:

```markdown
## Session Summary: [DATE]

### Work Completed
- Created specification for [###-F]
- Resolved 5 clarification questions
- Achieved RULEMAP score 8.5

### Key Decisions
- [###-D-001]: Using JWT for authentication
- [###-D-002]: PostgreSQL for primary database

### Current State
- Phase: Planning
- Next action: Break down into tasks

### Essential Context
[Minimal context needed for next session]
```

## Best Practices

### 1. Clear Handoff Boundaries
- Document what's complete
- Note what's pending
- List essential context

### 2. Progress Tracking
Update progress.md after EVERY agent action:
```markdown
- ✅ [Agent]: [Action completed]
- 🔄 [Agent]: [Action in progress]
- ⛔ [Agent]: [Blocked on X]
```

### 3. Quality Gates
Each phase must meet criteria before handoff:

| Phase | Gate Criteria |
|-------|--------------|
| Specify | RULEMAP ≥ 8.0, no [NEEDS CLARIFICATION] |
| Plan | All decisions made, milestones defined |
| Tasks | All requirements covered, dependencies mapped |
| Implement | Tests passing, code reviewed |
| QA | Acceptance criteria validated |

### 4. Error Recovery
If agent fails:
1. Log failure in progress.md
2. Capture context state
3. Create recovery checkpoint
4. Resume from last known good state

## Scripts

- `scripts/orchestrate.py` - Main orchestration controller
- `scripts/handoff.py` - Agent handoff protocol
- `scripts/context_compress.py` - Compress context for long sessions
