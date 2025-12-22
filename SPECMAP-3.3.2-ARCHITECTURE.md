# SpecMap 3.3.2 - Architecture One-Pager

**Quick Reference for Contributors & Power Users**
**Version 3.3.2**

---

## The Mental Model

```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│  SpecMap treats AI like a crash-prone process                  │
│  with no memory guarantees.                                    │
│                                                                │
│  That's why we use save files, cold start briefings,           │
│  and integrity checks.                                         │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## What SpecMap Is NOT

```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│  SpecMap is NOT a task manager    → Use Jira/Linear/Issues     │
│  SpecMap is NOT a workflow engine → Use n8n/Temporal/Airflow   │
│  SpecMap is NOT an agent framework → Use LangGraph/CrewAI      │
│  SpecMap is NOT a memory database → Use vector DBs             │
│                                                                │
│  SpecMap IS a state persistence layer.                         │
│  It interfaces with all of the above. It replaces none.        │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## The Core Idea

```
┌────────────────────────────────────────────────────────────────┐
│  AI doesn't forget—it evaporates.                              │
│                                                                │
│  SpecMap externalizes memory into three SAVE FILES.            │
│  progress.md is the heartbeat—a complete snapshot.             │
│                                                                │
│  Any agent, any time, cold start = instant resumption.         │
│                                                                │
│  If progress.md isn't updated, SpecMap is broken.              │
│  Everything else can be imperfect. This cannot.                │
│                                                                │
│  If forced to choose, preserve snapshot over history.          │
│  When in doubt, delete history before touching snapshot.       │
└────────────────────────────────────────────────────────────────┘
```

---

## Architecture

```
SpecMap Core (Required)              SpecMap Extended (Optional)
============================         ============================
                                     
SPECMAP.md ────→ Rules               .specmap/
  • Mental Model                     ├── agents/    → Custom agents
  • Critical Operations              ├── commands/  → Platform commands
  • Recovery Protocol                └── workflows/ → Automation
                                     
features.json ─→ Intent              features.archive.json → Old features
                                     
progress.md ───→ Reality             MCP Server → Protocol-based access
       ↑         (SAVE FILE)         Vector DB  → Long-term memory
       │                             
   THE HEARTBEAT                     ⚠️ SpecMap INTERFACES WITH these.
   • Last Known Good State              It does not ABSORB them.
   • Snapshot Integrity Check        
   • Cold Start Briefing             
   • Context Budget                  
```

---

## Source of Truth

| File | Contains | Updates | Token Target |
|------|----------|---------|--------------|
| **SPECMAP.md** | Rules + Recovery | Rarely | ~500 |
| **features.json** | Intent | Feature add/complete | ~400 |
| **progress.md** | Reality (save file) | **EVERY action** | ~800 |
| **Total** | — | — | **< 2,000** |

---

## progress.md Structure (Priority Order)

```
SNAPSHOT SECTIONS (Sacred - Never Delete)     HISTORY SECTIONS (Archivable)
═══════════════════════════════════════════   ════════════════════════════
                                              
1. Last Known Good State    ← MOST CRITICAL   • Old session log entries
2. Resume Confidence                          • Resolved questions
3. Snapshot Integrity Check                   • Cleared blockers  
4. Context Budget                             • Completed backlog items
5. Active Task + Cold Start Briefing          
6. Feature Status Table                       
7. Recent Decisions                           

When in doubt, delete history before touching snapshot sections.
```

---

## Compaction-Proof Design

### Last Known Good State (Top of progress.md)

```markdown
> **Last Known Good State (2025-12-22 16:45):**  
> Feature 001: 2/5 tasks. On 001-T-003 (login endpoint). JWT signing next.
> No blockers. Decisions: D-001 (JWT), D-002 (RS256). Confidence: 5/5.
```

### Snapshot Integrity Check

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

### Cold Start Briefing (In Active Task)

```markdown
### Cold Start Briefing

**What:** Building POST /api/auth/login with JWT response.
**Why:** Feature 001, depends on T-001 (✅) and T-002 (✅).
**Where:** src/api/auth/login.ts
**Current State:** Endpoint scaffolded, JWT signing next.
**Next Step:** Implement generateToken() function.
**Blockers:** None.
```

---

## Resume Confidence

| Score | Meaning | Action |
|-------|---------|--------|
| 5/5 | Complete clarity | Proceed |
| 4/5 | Minor gaps | Proceed, note gaps |
| 3/5 | Some uncertainty | Proceed cautiously |
| 2/5 | Significant gaps | **Clarify first** |
| 1/5 | Lost | **Full reset** |

---

## 🛑 Critical Operations

**STOP and ask before:**
- Deleting files or data
- Database migrations
- Production API calls
- Git on main/master
- Actions that cost money
- Security-sensitive changes

---

## 🔄 Compaction Recovery

```
IF: Confusion, uncertainty, repeating questions

THEN:
1. STOP
2. READ Last Known Good State
3. RUN Snapshot Integrity Check
4. READ Cold Start Briefing  
5. CHECK Decisions table
6. UPDATE Resume Confidence
7. ASK if confidence < 3
```

---

## Decisions (With Rationale)

```markdown
## Decisions

> Trigger: "We decided..." → log with rationale (alternatives considered).

| ID | Decision | Rationale (Alternatives Considered) | Date |
|----|----------|-------------------------------------|------|
| D-001 | JWT tokens | Stateless, scalable. **Considered:** sessions—rejected for scaling. | 12-22 |
```

---

## Core Workflow

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
Update progress.md:
  • 🟢 entry + bullets
  • Cold Start Briefing
  • Last Known Good State
  • Resume Confidence
  • Decisions (if any)
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

## Context Budget Rules

| Threshold | Action |
|-----------|--------|
| > 600 tokens (features.json) | Archive completed features |
| > 1,200 tokens (progress.md) | Archive old sessions |
| > 2,000 tokens (total) | **Immediate cleanup** |

### Archive Hierarchy

```
KEEP (Sacred):                 DELETE FIRST (History):
─────────────────────────      ─────────────────────────
Last Known Good State          Old session log entries
Snapshot Integrity Check       Resolved questions
Cold Start Briefing            Cleared blockers
Active Task                    Completed backlog items
Feature Status                 
Recent Decisions               

⚠️ When in doubt, delete history before touching snapshot sections.
```

---

## The Five Rules

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  1. UPDATE PROGRESS.MD AFTER EVERY ACTION.                      │
│     If it's not updated, SpecMap is broken.                     │
│                                                                 │
│  2. RUN SNAPSHOT INTEGRITY CHECK BEFORE PROCEEDING.             │
│     Correctness over momentum.                                  │
│                                                                 │
│  3. KEEP COLD START BRIEFING CURRENT.                           │
│     Any agent must be able to continue cold.                    │
│                                                                 │
│  4. LOG DECISIONS WITH RATIONALE.                               │
│     "We decided..." → capture alternatives considered.          │
│                                                                 │
│  5. ASK BEFORE CRITICAL OPERATIONS.                             │
│     Deletes, migrations, production, money, security.           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## ID System & Status

```
IDs:                           Status Emojis:
001          → Feature         🟢 Complete
001-T-001    → Task            🟡 Active / Session End
001-A-001    → Acceptance      ⚪ Pending
D-001        → Decision        🔴 Blocked
Q-001        → Question        🔵 New Session
B-001        → Blocker
```

---

## RULEMAP Modes

| Mode | Elements | Threshold | Use For |
|------|----------|-----------|---------|
| **Lite** | R, U, E, P | ≥3/4 | Most features |
| **Full** | R, U, L, E, M, A, P | ≥8/10 | Major products |

---

## Platform Support

Works with: Claude Code, Cursor, Windsurf, Copilot, Cody, any AI that reads files.

**Switch agents mid-project.** New agent reads save file, continues.

---

## Strategic Roadmap

| Feature | Purpose | Status |
|---------|---------|--------|
| MCP Server | Protocol-based state | Planned |
| Vector DB | Long-term memory | Planned |
| Multi-Agent | Orchestration | Designed |
| Observability | Evaluation hooks | Designed |

> **Boundary:** SpecMap **interfaces with** these. It does not **absorb** them.

---

## Anti-Patterns

| ❌ Don't | ✅ Do |
|----------|-------|
| Skip progress updates | Update EVERY action |
| Skip Integrity Check | Run before proceeding |
| Trim snapshot sections first | Delete history first |
| Vague Cold Start Briefing | Include What/Why/Where/State/Next |
| Omit decision rationale | Include alternatives considered |
| Let SpecMap become a framework | Keep it boring and portable |

---

**SpecMap 3.3.2** - Plan. Build. Track. Ship.

*Because your AI should remember where you left off—even when it forgets.*
