# SpecMap 3.3.2

## The Complete AI-Powered Project Operating System

**One file. Any AI agent. Perfect resumability. Compaction-proof.**

---

## Why SpecMap Exists

> **AI doesn't forget—it evaporates.**
>
> SpecMap turns ephemeral AI sessions into a durable, resumable project memory that survives context compaction, session breaks, and even switching AI agents entirely.

### The Mental Model

> **SpecMap treats AI like a crash-prone process with no memory guarantees.**

That single idea explains everything:
- Why we use save files instead of logs
- Why Cold Start Briefings exist
- Why we track context budgets
- Why human checkpoints matter

If you've ever worked with crash recovery, database journaling, or distributed systems, you'll recognize the pattern. SpecMap applies the same discipline to AI-assisted development.

### What SpecMap Is NOT

| SpecMap is NOT... | Use instead... |
|-------------------|----------------|
| A task manager | Jira, Linear, GitHub Issues |
| A workflow engine | n8n, Temporal, Airflow |
| An agent framework | LangGraph, AutoGPT, CrewAI |
| A memory database | Vector DBs (Pinecone, Weaviate) |

**SpecMap is a state persistence layer.** It interfaces with all of the above. It replaces none of them.

---

## Your First 10 Minutes with SpecMap

Here's what it actually feels like:

**Minute 0-2:** Bootstrap finishes. You have three files. progress.md shows your first Active Task with a complete Cold Start Briefing.

**Minute 2-15:** You work with your AI. It completes tasks, updates progress.md after each one. You see 🟢 entries appearing with timestamps.

**Minute 15:** You step away. Lunch. A meeting. Whatever.

**Minute 45:** You come back. You say: "Let's continue."

**Minute 45:30:** The AI reads progress.md, finds the Cold Start Briefing, sees exactly where you left off, and picks up mid-thought.

**That's it.** No re-explaining. No "what were we doing?" No lost context.

Even if context compacts mid-session or you switch to a completely different AI agent, progress.md contains everything needed to continue without missing a beat.

---

## SpecMap Core vs Extended

**Most users only need SpecMap Core.** The extended features are optional power-ups.

### SpecMap Core (90% of Users)

Everything you need for perfect resumability:

```
your-project/
├── SPECMAP.md        # Project rules (agent reads this first)
├── features.json     # Features, tasks, acceptance criteria
└── progress.md       # The "heartbeat" - updated after EVERY action
```

**If you only ever use these three files, SpecMap still delivers perfect resumability.**

### SpecMap Extended (Power Users)

Optional additions when you need them:

| Feature | What It Adds | When to Use |
|---------|--------------|-------------|
| `.specmap/` folder | Custom commands, workflows | Large or long-running projects |
| RULEMAP Full | 7-element PRD scoring | External products, major features |
| GitHub Sync | Issues ↔ features.json | Team collaboration |
| MCP Server | Protocol-based state access | Multi-agent orchestration |
| Vector DB | Long-term semantic memory | Projects spanning months |

> **Important:** SpecMap **interfaces with** these systems. It does not **absorb** them. SpecMap's power is that it stays boring, legible, and portable.

---

## Quick Start

### Step 1: Download

Download `SPECMAP-INIT.md` from this repository.

### Step 2: Initialize

1. Create a new folder for your project
2. Drag `SPECMAP-INIT.md` into the folder
3. Open your AI tool (Claude Code, Cursor, etc.)
4. Tell the agent: **"Read SPECMAP-INIT.md and set up this project"**

### Step 3: Answer Questions

The agent will ask you about:
- Project name and description
- Tech stack (framework, database, libraries)
- Features you want to build (3-7 features)
- Environment variables needed
- Optional integrations (all optional—defaults are fine)

### Step 4: Start Building

The agent creates your files and you're ready to go. That's it.

---

## The One Rule That Cannot Break

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   If progress.md isn't updated, SpecMap is broken.              │
│                                                                 │
│   Everything else can be imperfect. This cannot.                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

This is the discipline that makes everything else work. The agent updates progress.md after every completed action—no exceptions.

---

## The Three Core Files

### Source of Truth

| File | Contains | Purpose | Updates When |
|------|----------|---------|--------------|
| **SPECMAP.md** | Rules | How to work on this project | Rarely (project setup) |
| **features.json** | Intent | What should exist, requirements, "done" criteria | Feature added or completed |
| **progress.md** | Reality | What actually happened, active task, decisions | **After EVERY action** |

### The Save File Philosophy

SpecMap files are designed as **save files, not logs**:

| Log Approach | Save File Approach (SpecMap) |
|--------------|------------------------------|
| Records what happened | Records current state |
| Requires reading history | Snapshot is sufficient |
| Context-dependent | Context-independent |
| Vulnerable to compaction | **Compaction-proof** |

### Priority Under Pressure

> **If forced to choose, preserve snapshot over history.**
>
> **When in doubt, delete history before touching snapshot sections.**

The Cold Start Briefing and Last Known Good State are sacred. Session logs, backlog, and questions can be archived if context budget demands it.

---

## Compaction-Proof Design

### The Problem

AI context windows can compact without warning. When this happens:
- The agent loses conversation history
- Earlier decisions are forgotten
- Work may be repeated or contradicted

### The Solution: Cold Start Briefing

Every Active Task includes a complete briefing that makes conversation history unnecessary:

```markdown
## 🟡 Active Task

| Field | Value |
|-------|-------|
| **Task** | Implement login endpoint |
| **ID** | 001-T-003 |
| **Feature** | 001 - User Authentication |
| **Started** | 14:35 |

### Cold Start Briefing
**What:** Building POST /api/auth/login that validates credentials and returns JWT.

**Why:** Part of Feature 001 (User Auth). Depends on 001-T-001 (user model) and 001-T-002 (password hashing) which are complete.

**Where:** Working in `src/api/auth/login.ts`. Tests in `src/api/auth/__tests__/`.

**Current State:** Endpoint scaffolded, need to add JWT signing logic using the `jsonwebtoken` library. Decision D-002 established we're using RS256 algorithm.

**Next Step:** Implement `generateToken()` function, then wire up to endpoint.

**Blockers:** None.
```

A new agent reading this can start immediately—no conversation history required.

### Last Known Good State

At the very top of progress.md, a one-paragraph snapshot:

```markdown
> **Last Known Good State (2025-12-22 16:45):**  
> Feature 001 (User Auth): 2/5 tasks complete. Currently on 001-T-003 (login endpoint). 
> Endpoint scaffolded, JWT signing next. No blockers. Key decisions: D-001 (JWT tokens), 
> D-002 (RS256 algorithm). Resume confidence: 5/5.
```

### Snapshot Integrity Check

Before proceeding, the agent verifies the snapshot is accurate:

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

### Archive Hierarchy

When context budget is tight, archive in this order:

```
KEEP (Sacred - Never Delete First):     DELETE FIRST (History):
────────────────────────────────────    ────────────────────────
Last Known Good State                   Old session log entries
Snapshot Integrity Check                Resolved questions
Resume Confidence                       Cleared blockers
Context Budget                          Completed backlog items
Active Task + Cold Start Briefing       
Feature Status Table                    
Recent Decisions                        

⚠️ When in doubt, delete history before touching snapshot sections.
```

---

## Context Budget Tracking

Since AI models don't expose context usage, track it manually:

```markdown
## 📊 Context Budget (Estimated)

| File | Est. Tokens | Status |
|------|-------------|--------|
| SPECMAP.md | ~500 | ✅ Lean |
| features.json | ~350 | ✅ Lean |
| progress.md | ~800 | ✅ Lean |
| **Total Core** | **~1,650** | ✅ Under 2,000 |

> **Rule:** If Total Core exceeds 2,000 tokens, archive completed work immediately.
> **Priority:** If forced to choose, preserve snapshot over history.
```

---

## The Workflow

### Starting a Session

```
1. Agent reads progress.md
2. Checks Last Known Good State (one-paragraph snapshot)
3. Runs Snapshot Integrity Check
4. Checks Resume Confidence (if < 3, clarify first)
5. Reads Cold Start Briefing in Active Task
6. Continues from where it left off
7. Does NOT repeat 🟢 completed work
```

### After Every Action

```
1. Add 🟢 entry with timestamp: 🟢 **14:35** - Completed user auth API
2. Add 2-4 bullet points of specifics
3. Update Feature Status table if needed
4. Update Active Task (including Cold Start Briefing)
5. Update Last Known Good State
6. Update Resume Confidence
7. Save immediately
```

### Ending a Session

```
1. Add 🟡 Session ended entry with current state
2. Update Last Known Good State
3. Ensure Cold Start Briefing is complete
4. Run Snapshot Integrity Check
5. Confirm another agent could continue cold
```

---

## Resume Confidence Check

| Score | Meaning | Action |
|-------|---------|--------|
| 5/5 | Complete clarity | Proceed immediately |
| 4/5 | Minor gaps | Proceed, note gaps |
| 3/5 | Some uncertainty | Proceed cautiously |
| 2/5 | Significant gaps | Clarify first |
| 1/5 | Lost | Full context reset needed |

---

## Critical Operations (Human Approval Required)

Some actions require explicit human confirmation:

```markdown
## 🛑 Critical Operations

Pause and ask before:
- [ ] Deleting files or data
- [ ] Database migrations or schema changes
- [ ] External API calls with production credentials
- [ ] Git operations on main/master/production branches
- [ ] Any action that costs money (API calls, deployments)
- [ ] Security-sensitive changes (auth, permissions, encryption)
```

The agent should state what it's about to do and wait for "proceed" before executing.

---

## Capturing Decisions (With Rationale)

> **Trigger:** Any time the answer starts with "we decided…" → log a decision with rationale.

```markdown
## Decisions

| ID | Decision | Rationale (Alternatives Considered) | Date |
|----|----------|-------------------------------------|------|
| D-001 | Use JWT for auth tokens | Stateless (scales horizontally without session affinity), industry standard. **Considered:** server sessions—rejected due to horizontal scaling requirements. | 2025-12-22 |
```

The rationale column shows what was considered and why alternatives were rejected.

---

## Compaction Recovery Protocol

When an agent loses context mid-session:

```
IF you notice:
- Loss of conversation context
- Confusion about what was discussed  
- Uncertainty about decisions made
- Repeating questions already answered

THEN:
1. STOP. Do not guess or continue blindly.
2. Read progress.md completely (especially Last Known Good State).
3. Run Snapshot Integrity Check.
4. Read the Cold Start Briefing in Active Task.
5. Check the Decisions table for prior choices.
6. Update Resume Confidence (probably 2/5 or lower).
7. If confidence < 3, ask: "I may have lost context. Should I proceed 
   with [Active Task] or do you need to brief me?"

DO NOT:
- Assume you remember the conversation
- Repeat completed work (check 🟢 entries)
- Make decisions that contradict the Decisions table
- Execute Critical Operations without re-confirming
```

---

## RULEMAP: Two Modes

### RULEMAP Lite (Default)

For most features - 4 elements, score ≥3/4:

| Element | Focus |
|---------|-------|
| **R**ole | Who owns this? |
| **U**nderstanding | What problem? |
| **E**lements | What exactly? |
| **P**erformance | How to measure? |

### RULEMAP Full (Major Features)

For external products - 7 elements, score ≥8/10:

| Element | Focus |
|---------|-------|
| **R**ole | Authority & Identity |
| **U**nderstanding | Objectives & Success |
| **L**ogic | Structure & Architecture |
| **E**lements | Specifications & Constraints |
| **M**ood | Experience & Feel |
| **A**udience | Stakeholders & Users |
| **P**erformance | Metrics & KPIs |

---

## ID System

| ID | Meaning |
|----|---------|
| `001` | Feature 001 |
| `001-T-001` | Task 1 of Feature 001 |
| `001-A-001` | Acceptance criterion 1 |
| `D-001` | Decision 1 |
| `Q-001` | Question 1 |
| `B-001` | Blocker 1 |

---

## Status Emojis

| Emoji | Meaning |
|-------|---------|
| 🟢 | Complete |
| 🟡 | In Progress / Session marker |
| ⚪ | Pending |
| 🔴 | Blocked |
| 🔵 | In Review / New Session |

---

## Adding New Work

| Type | Where to Add | Trigger |
|------|--------------|---------|
| New feature | `features.json` + Feature Status table | — |
| New task | `features.json` → tasks array | — |
| Quick idea | `progress.md` → Backlog table | — |
| Decision made | `progress.md` → Decisions table | "We decided..." |

**Never create separate task files or to-do documents.**

---

## Works With Any AI

SpecMap 3.3.2 is agent-agnostic:

- ✅ Claude Code
- ✅ Cursor AI
- ✅ Windsurf
- ✅ GitHub Copilot
- ✅ Cody
- ✅ Any AI that can read markdown files

The save-file design means you can even switch agents mid-project. The new agent reads progress.md and continues.

---

## Best Practices

### DO ✅

- Update `progress.md` after every action
- Run Snapshot Integrity Check before resuming
- Keep Cold Start Briefing complete and current
- Log decisions with explicit rationale
- Monitor context budget
- Delete history before touching snapshot sections
- Ask for approval on Critical Operations

### DON'T ❌

- Create separate task files
- Skip progress updates
- Skip Snapshot Integrity Check
- Write vague Cold Start Briefings
- Omit rationale from decisions
- Delete snapshot sections to save space
- Execute Critical Operations without approval
- Let SpecMap become a framework

---

## Troubleshooting

### Agent seems confused or repeating work?

Context may have compacted. Tell the agent: "Read progress.md from the top, run Snapshot Integrity Check, and tell me your Resume Confidence."

### Lost context after a break?

Normal. Tell the agent: "Read progress.md and continue from the Cold Start Briefing."

### Agent contradicting earlier decisions?

Point to Decisions table: "Check decision D-00X before proceeding."

### Context budget getting high?

Archive in this order:
1. Old session log entries
2. Resolved questions and cleared blockers
3. Completed features to `features.archive.json`

**Never archive first:** Last Known Good State, Cold Start Briefing, Active Task, recent Decisions

### Switching AI agents mid-project?

No problem. New agent reads progress.md and continues. That's the whole point.

---

## File Size Guidelines

| File | Target | Warning | Action |
|------|--------|---------|--------|
| SPECMAP.md | ~500 tokens | >650 | Trim standards section |
| features.json | ~400 tokens | >600 | Archive completed features |
| progress.md | ~800 tokens | >1,200 | Archive old sessions |
| **Total Core** | **<1,700** | **>2,000** | **Immediate cleanup** |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 3.3.2 | 2025-12 | Explicit non-goals, archive hierarchy, "delete history first" guardrail, 60-second explainer, worked failure example |
| 3.3.1 | 2025-12 | Decision rationale wording, Snapshot Integrity Check, priority under pressure, mental model |
| 3.3 | 2025-12 | Compaction-proofing, Cold Start Briefing, Context Budget, Critical Operations |
| 3.0 | 2025-12 | Core vs Extended, RULEMAP Lite, Resume Confidence, decision triggers |

---

## Strategic Roadmap

| Feature | Purpose |
|---------|---------|
| **MCP Server** | Protocol-based state access for multi-agent systems |
| **Vector DB Integration** | Long-term semantic memory for large projects |
| **Multi-Agent Workflows** | Hierarchical and graph-based orchestration |
| **Observability Hooks** | Integration with evaluation platforms |

> **Important:** SpecMap **interfaces with** these systems. It does not **absorb** them.

---

## Get Started

1. Download `SPECMAP-INIT.md`
2. Drag into your project folder
3. Tell your AI: "Read SPECMAP-INIT.md and set up this project"
4. Answer the questions
5. Start building!

---

**SpecMap 3.3.2** - Plan. Build. Track. Ship.

*Because your AI should remember where you left off—even when it forgets.*

---

## License

MIT License - Use freely in your projects.

## Contributing

SpecMap is developed by Monomoy Strategies.

Feedback and suggestions welcome!
