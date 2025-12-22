# SpecMap 3.3.2: Vision & Architecture Document

**Author**: Bill @ Monomoy Strategies  
**Date**: December 22, 2025  
**Status**: Production Ready  
**Version**: 3.3.2

---

## Executive Summary

> **AI doesn't forget—it evaporates.**
>
> SpecMap turns ephemeral AI sessions into a durable, resumable project memory that survives context compaction, session breaks, and even switching AI agents entirely.

### The Mental Model

> **SpecMap treats AI like a crash-prone process with no memory guarantees.**

That single sentence explains everything:
- Why we use save files instead of logs
- Why Cold Start Briefings exist
- Why we run Snapshot Integrity Checks
- Why we track context budgets
- Why human checkpoints matter

If you've ever worked with crash recovery, database journaling, or distributed systems, you'll recognize the pattern. SpecMap applies the same discipline to AI-assisted development.

### What SpecMap Is NOT

Before going further, let's be clear about scope:

| SpecMap is NOT... | Use instead... |
|-------------------|----------------|
| A task manager | Jira, Linear, GitHub Issues |
| A workflow engine | n8n, Temporal, Airflow |
| An agent framework | LangGraph, AutoGPT, CrewAI |
| A memory database | Vector DBs (Pinecone, Weaviate) |

**SpecMap is a state persistence layer.** It interfaces with all of the above. It replaces none of them.

### The One Rule That Cannot Break

> **If progress.md isn't updated, SpecMap is broken.**
>
> Everything else can be imperfect. This cannot.

---

## Part 1: Design Philosophy

### The Four Problems We Solve

| Problem | Impact | SpecMap Solution |
|---------|--------|------------------|
| **Context Evaporation** | AI loses project understanding after breaks | progress.md captures complete state after every action |
| **Context Compaction** | AI silently loses context mid-session | Cold Start Briefing enables instant recovery |
| **Workflow Fragmentation** | Tasks scattered across files | Everything in 3 core files |
| **Platform Lock-in** | Systems designed for one AI tool | Save file design works with any agent |

### Core Principles

1. **Save File, Not Log** - progress.md is a complete snapshot, not a history
2. **Cold Start Ready** - Any agent can continue with zero prior context
3. **Compaction-Proof** - Critical state survives context window limits
4. **Integrity First** - Snapshot correctness over momentum
5. **Agent Agnostic** - Works with any AI that can read markdown
6. **Context Efficient** - Total core files < 2,000 tokens
7. **Human Readable** - No special tools required to understand state

### The Save File Philosophy

| Log Approach | Save File Approach (SpecMap) |
|--------------|------------------------------|
| Records what happened | Records current state |
| Requires reading history | Snapshot is sufficient |
| Context-dependent | Context-independent |
| Vulnerable to compaction | **Compaction-proof** |
| Needs conversation context | **Cold start ready** |

### Priority Under Pressure

> **If forced to choose, preserve snapshot over history.**
>
> **When in doubt, delete history before touching snapshot sections.**

The Cold Start Briefing and Last Known Good State are sacred. Session logs, backlog, and questions can be archived if context budget demands it.

---

## Part 2: What It Feels Like

### Your First 10 Minutes with SpecMap

**Minute 0-2:** Bootstrap finishes. You have three files. progress.md shows your first Active Task with a complete Cold Start Briefing.

**Minute 2-15:** You work with your AI. It completes tasks, updates progress.md after each one. You see 🟢 entries appearing with timestamps.

**Minute 15:** You step away. Lunch. A meeting. Whatever.

**Minute 45:** You come back. You say: "Let's continue."

**Minute 45:30:** The AI reads progress.md, runs Snapshot Integrity Check, finds the Cold Start Briefing, and picks up mid-thought.

**That's it.** No re-explaining. No "what were we doing?" No lost context.

### The Compaction Recovery Experience

**Minute 60:** You've been working for a while. Suddenly the AI seems confused, asks a question you already answered.

**What happened:** Context window compacted. The AI lost conversation history.

**Minute 60:15:** The AI recognizes the confusion, reads progress.md from the top, runs Snapshot Integrity Check, checks the Cold Start Briefing and Decisions table, and continues without missing a beat.

**That's the compaction-proof design in action.**

---

## Part 3: Core vs Extended Model

### SpecMap Core (90% of Users)

Three files designed as save files:

```
project/
├── SPECMAP.md        # Rules + Critical Operations + Recovery Protocol
├── features.json     # Intent - what should exist
└── progress.md       # Reality - complete save file with Cold Start Briefing
```

**If you only use these three files, SpecMap still delivers full value.**

### SpecMap Extended (Power Users)

Optional additions for larger projects:

```
project/
├── SPECMAP.md
├── features.json
├── progress.md
│
├── .specmap/                    # Extended features
│   ├── config.yaml              # Project configuration
│   ├── agents/                  # Custom AI agent definitions
│   ├── commands/                # Platform-specific commands
│   └── workflows/               # Automation workflows
│
├── features.archive.json        # Archived completed features
│
└── docs/                        # Optional documentation
    ├── prd/                     # PRD documents (RULEMAP Full)
    └── decisions/               # ADR-style records (extended)
```

### The Boundary Principle

> **SpecMap interfaces with MCP, Vector DB, and multi-agent systems. It does not absorb them.**
>
> SpecMap's power is that it stays boring, legible, and portable.

Don't let the roadmap turn into scope creep. SpecMap is a state persistence layer, not a framework.

---

## Part 4: The Three Core Files

### Source of Truth Model

| File | Contains | Purpose | Updates When |
|------|----------|---------|--------------|
| **SPECMAP.md** | Rules | How to work + recovery protocols | Rarely (setup) |
| **features.json** | Intent | What should exist | Feature added/completed |
| **progress.md** | Reality | Complete save file | **After EVERY action** |

### 1. SPECMAP.md (~500 tokens)

The rulebook the AI reads first. Contains:

- **The Mental Model** - crash-prone process, no memory guarantees
- **The One Rule** - progress.md must be updated
- **Save File Philosophy** - design for cold start
- **Priority Under Pressure** - snapshot over history
- **Before ANY Work** - reading checklist
- **After EVERY Action** - update checklist
- **Critical Operations** - human approval required
- **Compaction Recovery Protocol** - what to do when lost
- **Adding New Work** - where everything goes
- **Source of Truth** - intent vs reality
- **Project Overview** - description and target user
- **Tech Stack** - framework, database, libraries
- **Commands** - dev, test, build, lint
- **Security Checklist** - pre-commit and pre-complete
- **Standards** - coding conventions
- **Verification Checklist** - agent self-check

### 2. features.json (~200-600 tokens active)

Structured intent:

```json
{
  "project": "project-name",
  "version": "0.1.0",
  "features": [
    {
      "id": "001",
      "name": "Feature Name",
      "status": "in-progress",
      "tasks": [
        { "id": "001-T-001", "description": "Task", "status": "complete" }
      ],
      "acceptance": [
        { "id": "001-A-001", "description": "Testable criterion", "passing": false }
      ]
    }
  ],
  "backlog": [],
  "decisions": []
}
```

**Archive Rule:** When 5+ features complete or >600 tokens, archive to `features.archive.json`.

### 3. progress.md (~600-1,000 tokens) - THE SAVE FILE

Complete snapshot for cold start. **Structure matters—snapshot sections come first:**

```markdown
# Progress Tracker

## SNAPSHOT SECTIONS (Sacred - Never Delete First)

> **Last Known Good State (timestamp):**  
> [One paragraph snapshot]

## Resume Confidence
[Table: confidence, missing info, last verified]

## ✓ Snapshot Integrity Check
[Preflight checklist]

## 📊 Context Budget
[Token estimates]

## 🟡 Active Task
[Current task with Cold Start Briefing]

## Feature Status
[All features with progress]

## Decisions
[With rationale]

---

## HISTORY SECTIONS (Archive First When Needed)

## Session Log
[Timestamped entries]

## Backlog | Questions | Blockers
[Tables]

## Resume Instructions
[Steps for any agent]
```

---

## Part 5: Compaction-Proof Design

### The Problem: Context Window Opacity

AI models don't expose context usage:

| What We Want | What We Get |
|--------------|-------------|
| "You have 47% context remaining" | Nothing |
| "Warning: approaching limit" | Sudden degradation |
| "These tokens are being dropped" | Silent quality loss |

Performance degrades quadratically with context length, but we can't see where we are on that curve.

### The Solution: Design for the Crash

Since we can't see the gauge, we design for recovery:

#### 1. Last Known Good State

One paragraph at the top of progress.md:

```markdown
> **Last Known Good State (2025-12-22 16:45):**  
> Feature 001 (User Auth): 2/5 tasks complete. Currently on 001-T-003 (login endpoint). 
> Endpoint scaffolded, JWT signing next. No blockers. Key decisions: D-001 (JWT tokens), 
> D-002 (RS256 algorithm). Resume confidence: 5/5.
```

#### 2. Cold Start Briefing

Every Active Task includes complete context:

```markdown
### Cold Start Briefing

**What:** Building POST /api/auth/login that validates credentials and returns JWT.

**Why:** Part of Feature 001 (User Auth). Depends on 001-T-001 (user model) and 
001-T-002 (password hashing) which are complete.

**Where:** Working in `src/api/auth/login.ts`. Tests in `src/api/auth/__tests__/`.

**Current State:** Endpoint scaffolded, need to add JWT signing logic using the 
`jsonwebtoken` library. Decision D-002 established we're using RS256 algorithm.

**Next Step:** Implement `generateToken()` function, then wire up to endpoint.

**Blockers:** None.
```

#### 3. Snapshot Integrity Check

Preflight verification before proceeding:

```markdown
## ✓ Snapshot Integrity Check

Before proceeding, verify:
- [ ] Last Known Good State reflects current reality
- [ ] Active Task matches Feature Status table
- [ ] Cold Start Briefing is accurate and complete
- [ ] Resume Confidence is set honestly
- [ ] Decisions table includes recent choices

> If any box is unchecked, fix it before doing new work.
```

#### 4. Archive Hierarchy

When context budget is tight, archive in this order:

```
KEEP (Sacred):                 DELETE FIRST (History):
─────────────────────────      ─────────────────────────
Last Known Good State          Old session log entries
Snapshot Integrity Check       Resolved questions
Resume Confidence              Cleared blockers
Context Budget                 Completed backlog items
Active Task + Cold Start       
Feature Status                 
Recent Decisions               

⚠️ When in doubt, delete history before touching snapshot sections.
```

---

## Part 6: Human-in-the-Loop Patterns

### Critical Operations (Require Approval)

Some actions need explicit human confirmation:

```markdown
## 🛑 Critical Operations

Pause and ask before:
- [ ] Deleting files or data
- [ ] Database migrations or schema changes
- [ ] External API calls with production credentials
- [ ] Git operations on main/master/production branches
- [ ] Any action that costs money
- [ ] Security-sensitive changes
```

### Resume Confidence Scale

| Score | Meaning | Action |
|-------|---------|--------|
| 5/5 | Complete clarity | Proceed immediately |
| 4/5 | Minor gaps | Proceed, note gaps |
| 3/5 | Some uncertainty | Proceed cautiously |
| 2/5 | Significant gaps | Clarify first |
| 1/5 | Lost | Full context reset |

---

## Part 7: Decision Capture with Rationale

### The Decision Trigger

> **Any time the answer starts with "we decided…" → log a decision with explicit rationale.**

### Enhanced Decision Format

```markdown
## Decisions

| ID | Decision | Rationale (Alternatives Considered) | Date |
|----|----------|-------------------------------------|------|
| D-001 | Use JWT for auth tokens | Stateless (scales horizontally without session affinity), industry standard. **Considered:** server sessions—rejected due to horizontal scaling requirements. | 2025-12-22 |
```

---

## Part 8: RULEMAP - Two Modes

### RULEMAP Lite (Default)

For most features - 4 elements, score ≥3/4:

| Element | Focus | Key Question |
|---------|-------|--------------|
| **R**ole | Ownership | Who's responsible? |
| **U**nderstanding | Problem | What are we solving? |
| **E**lements | Specs | What exactly must be built? |
| **P**erformance | Metrics | How do we measure success? |

### RULEMAP Full (Major Features)

For external products - 7 elements, score ≥8/10:

| Element | Focus |
|---------|-------|
| **R**ole | Authority & Identity |
| **U**nderstanding | Objectives & Success Criteria |
| **L**ogic | Structure & Architecture |
| **E**lements | Specifications & Constraints |
| **M**ood | Experience & Feel |
| **A**udience | Stakeholders & Users |
| **P**erformance | Metrics & KPIs |

---

## Part 9: Workflow

### The Core Loop

```
START
  │
  ▼
Read Last Known Good State
  │
  ▼
Run Snapshot Integrity Check ──Fails?──→ FIX FIRST
  │
  ▼
Check Resume Confidence ──< 3?──→ CLARIFY
  │
  ▼
Read Cold Start Briefing
  │
  ▼
Check Decisions table
  │
  ▼
DO WORK
  │
  ▼
Update progress.md (snapshot sections + entry)
  │
  ▼
More work? ─Yes→ [DO WORK]
  │
  No
  │
  ▼
Add 🟡 Session ended
Run Snapshot Integrity Check
  │
  ▼
DONE
```

---

## Part 10: Success Metrics

### Developer Experience

| Metric | Target |
|--------|--------|
| Bootstrap time | < 5 minutes |
| Cold start recovery | < 30 seconds |
| Context compaction recovery | < 1 minute |
| Agent switch time | < 1 minute |

### Project Quality

| Metric | Target |
|--------|--------|
| Resumability | 100% from any state |
| Compaction recovery | 100% without user re-briefing |
| Snapshot integrity | 100% pass rate |
| Decisions captured | 100% with rationale |

---

## Part 11: Strategic Roadmap

### SpecMap Extended (Planned)

| Feature | Purpose | Status |
|---------|---------|--------|
| **MCP Server** | Protocol-based state access | Planned |
| **Vector DB Integration** | Long-term semantic memory | Planned |
| **Multi-Agent Workflows** | Hierarchical orchestration | Designed |
| **Observability Hooks** | Evaluation platform integration | Designed |

### The Boundary Principle

> **SpecMap interfaces with these systems. It does not absorb them.**
>
> SpecMap's power is that it stays boring, legible, and portable.

---

## Appendix A: Worked Failure Example

This appendix demonstrates SpecMap's compaction recovery in action.

### The Setup

You're working with Claude Code on a user authentication feature. You've been at it for about an hour.

**progress.md state:**
```markdown
> **Last Known Good State (14:35):**  
> Feature 001 (User Auth): 2/5 tasks complete. On 001-T-003 (login endpoint).
> Password hashing done. JWT signing next using RS256 (D-002). Confidence: 5/5.

## 🟡 Active Task

| Field | Value |
|-------|-------|
| **Task** | Implement login endpoint |
| **ID** | 001-T-003 |
| **Feature** | 001 - User Authentication |
| **Started** | 14:00 |

### Cold Start Briefing

**What:** Building POST /api/auth/login that validates credentials and returns JWT.

**Why:** Part of Feature 001. Depends on 001-T-001 (user model ✅) and 
001-T-002 (password hashing ✅).

**Where:** src/api/auth/login.ts

**Current State:** Endpoint scaffolded. bcrypt verification working. 
Need to add JWT signing with RS256 per decision D-002.

**Next Step:** Implement generateToken() function using jsonwebtoken library.

**Blockers:** None.

## Decisions

| ID | Decision | Rationale | Date |
|----|----------|-----------|------|
| D-001 | Use JWT for auth | Stateless, scalable. Rejected sessions. | 14:00 |
| D-002 | Use RS256 algorithm | Asymmetric keys safer. Rejected HS256. | 14:15 |
```

### The Crash

**14:45** - You've been discussing implementation details. Then:

```
You: "Okay, so let's implement the token signing now."

AI:  "Sure! Before I implement that, can you remind me what authentication 
     approach we're using? Are we doing session-based auth or tokens?"
```

**What happened:** Context window compacted. The AI lost the conversation where you discussed and decided on JWT with RS256. It's now confused.

### The Recovery (Without SpecMap)

```
You: "We already decided this. JWT tokens."
AI:  "Got it. What algorithm should I use for signing?"
You: "RS256. We discussed this."
AI:  "Okay. And where is the endpoint file?"
You: "src/api/auth/login.ts. I already told you this."
AI:  "Right, and is password verification already done?"
You: [frustrated] "Yes! Can you just read the code?"
```

**Time wasted: 5-10 minutes of re-explaining.**

### The Recovery (With SpecMap)

```
You: "We already decided this. Read progress.md and continue."

AI:  [Reads progress.md]
     
     "Got it. I've recovered context:
     
     • Feature 001-T-003: Login endpoint
     • Location: src/api/auth/login.ts  
     • Current state: Endpoint scaffolded, bcrypt working
     • Next step: Implement generateToken() with RS256 (per D-002)
     • JWT decision rationale: Stateless and scalable (D-001)
     
     Resuming from generateToken() implementation now."
     
     [Continues working correctly]
```

**Time to recover: ~30 seconds.**

### Why This Works

1. **Last Known Good State** told the AI exactly where things stood
2. **Cold Start Briefing** had all the context needed to continue
3. **Decisions table** preserved the *why* behind JWT and RS256 choices
4. **No re-explaining required** - all context externalized in files

### The Lesson

The AI didn't remember the conversation. But it didn't need to.

Everything critical was in progress.md, designed to be read cold by any agent at any time.

**That's the save file philosophy in action.**

---

## Appendix B: Quick Reference

### The Mental Model

> **SpecMap treats AI like a crash-prone process with no memory guarantees.**

### The One Rule

> **If progress.md isn't updated, SpecMap is broken.**

### The Priority

> **If forced to choose, preserve snapshot over history.**
> **When in doubt, delete history before touching snapshot sections.**

### The Three Files

```
SPECMAP.md      → Rules (read first)
features.json   → Intent (what should exist)
progress.md     → Reality (save file) ← THE HEARTBEAT
```

### The Five Rules

```
1. UPDATE progress.md AFTER EVERY ACTION.
2. RUN SNAPSHOT INTEGRITY CHECK BEFORE PROCEEDING.
3. KEEP COLD START BRIEFING CURRENT.
4. LOG DECISIONS WITH RATIONALE.
5. ASK BEFORE CRITICAL OPERATIONS.
```

### What SpecMap Is NOT

```
Not a task manager    → Use Jira/Linear
Not a workflow engine → Use n8n/Temporal
Not an agent framework → Use LangGraph/CrewAI
Not a memory database → Use vector DBs

SpecMap is a state persistence layer.
It interfaces with all of the above. It replaces none.
```

---

**SpecMap 3.3.2** - Plan. Build. Track. Ship.

*Because your AI should remember where you left off—even when it forgets.*
