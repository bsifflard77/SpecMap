# SpecMap in 60 Seconds

**The fastest way to understand what SpecMap does and why.**

---

## The Mental Model

> **SpecMap treats AI like a crash-prone process with no memory guarantees.**

AI context evaporates between sessions. It can compact mid-conversation without warning. SpecMap externalizes memory into files that survive these failures.

---

## The Three Files

```
SPECMAP.md      → Rules (how to work on this project)
features.json   → Intent (what we're building)
progress.md     → Reality (what's actually happening) ← THE HEARTBEAT
```

That's it. Three files. Any AI agent can read them.

---

## The Five Rules

```
1. UPDATE progress.md AFTER EVERY ACTION.
   If it's not updated, SpecMap is broken.

2. RUN SNAPSHOT INTEGRITY CHECK BEFORE PROCEEDING.
   Correctness over momentum.

3. KEEP COLD START BRIEFING CURRENT.
   Any agent must be able to continue cold.

4. LOG DECISIONS WITH RATIONALE.
   "We decided..." → capture why.

5. ASK BEFORE CRITICAL OPERATIONS.
   Deletes, migrations, production, money, security.
```

---

## What Recovery Looks Like

**The Crash:**
```
You: "Continue working on the login endpoint."
AI:  "What login endpoint? Can you explain what we're building?"
     (Context compacted. AI lost everything.)
```

**The Recovery:**
```
You: "Read progress.md and continue."
AI:  [Reads Last Known Good State]
     [Reads Cold Start Briefing]
     "Got it. We're on 001-T-003, implementing JWT signing 
      with RS256 per decision D-002. Resuming from 
      generateToken() function."
     (Continues without you re-explaining anything.)
```

**Time to recover: ~30 seconds.**

---

## What SpecMap Is NOT

- **Not a task manager** → Use Jira/Linear for that
- **Not a workflow engine** → Use n8n/Temporal for that  
- **Not an agent framework** → Use LangGraph/CrewAI for that
- **Not a memory database** → Use vector DBs for that

**SpecMap is a state persistence layer.** It interfaces with all of the above. It replaces none of them.

---

## The Payoff

| Without SpecMap | With SpecMap |
|-----------------|--------------|
| "What were we doing?" | Read Last Known Good State |
| Context compacts → confusion | Cold Start Briefing → instant recovery |
| Switch AI agents → start over | Switch agents → continue seamlessly |
| Decisions forgotten | Decisions table with rationale |
| Tasks scattered in 5 files | Everything in 3 files |

---

## Get Started

1. Download `SPECMAP-INIT.md`
2. Drag into your project folder
3. Tell your AI: "Read SPECMAP-INIT.md and set up this project"
4. Answer the questions
5. Start building

**Time to set up: ~5 minutes.**

---

**SpecMap** - Because your AI should remember where you left off.
