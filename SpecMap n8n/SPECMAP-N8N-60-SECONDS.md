# SpecMap-N8N in 60 Seconds

**The fastest way to understand what SpecMap-N8N does and why.**

---

## The Mental Model

> **SpecMap treats AI like a crash-prone process with no memory guarantees.**

AI context evaporates between sessions. It can compact mid-conversation without warning. SpecMap-N8N externalizes your workflow-building memory into files that survive these failures.

---

## The Three Files

```
SPECMAP.md        → Rules (how to work on this project)
workflows.json    → Intent (what automations we're building)
progress.md       → Reality (what's configured, what's next) ← THE HEARTBEAT
```

That's it. Three files. Any AI agent can read them.

---

## The Five Rules

```
1. UPDATE progress.md AFTER EVERY NODE CONFIGURED.
   If it's not updated, SpecMap is broken.

2. RUN SNAPSHOT INTEGRITY CHECK BEFORE PROCEEDING.
   Correctness over momentum.

3. KEEP COLD START BRIEFING CURRENT.
   Any agent must be able to continue cold.

4. LOG DECISIONS WITH RATIONALE.
   "We chose Webhook over Schedule because..." → capture why.

5. ASK BEFORE DESTRUCTIVE OPERATIONS.
   Deleting workflows, production credentials, activating untested workflows.
```

---

## What Recovery Looks Like

**The Crash:**
```
You: "Continue configuring the Slack notification node."
AI:  "What Slack node? Can you explain what workflow we're building?"
     (Context compacted. AI lost everything.)
```

**The Recovery:**
```
You: "Read progress.md and continue."
AI:  [Reads Last Known Good State]
     [Reads Cold Start Briefing]
     "Got it. Workflow 001 (New Lead Notification). We're on node 
      001-N-003 (Slack). HubSpot trigger is complete. Need to configure 
      message template with contact name and source. Channel is #sales 
      per decision D-001. Resuming."
     (Continues without you re-explaining anything.)
```

**Time to recover: ~30 seconds.**

---

## What SpecMap-N8N Is NOT

- **Not a workflow manager** → N8N itself handles that
- **Not a version control system** → Use Git for workflow JSON
- **Not an execution monitor** → Use N8N's built-in execution history
- **Not a substitute for understanding N8N** → You still need to know `$json`, expressions, and branches

**SpecMap-N8N is a state persistence layer for building workflows with AI.**

---

## The Payoff

| Without SpecMap-N8N | With SpecMap-N8N |
|---------------------|------------------|
| "Which node were we on?" | Read Cold Start Briefing |
| "Why did we use Webhook not Schedule?" | Check Decisions table |
| Context compacts → confusion | 30-second recovery |
| Switch AI agents → start over | Continue seamlessly |
| Forget credential status | Credentials table shows all |

---

## N8N-Specific Tracking

```markdown
## Workflow Status
| ID | Workflow | Nodes | Status | Tested |
|----|----------|-------|--------|--------|
| 001 | New Lead Notification | 4/5 | 🟡 Active | ⚪ Pending |

## Credentials Status  
| Service | Status | Tested |
|---------|--------|--------|
| HubSpot | ✅ Connected | ✅ |
| Slack | ✅ Connected | ⚪ |

## Error Handling
| Workflow | Strategy | Implemented |
|----------|----------|-------------|
| 001 | Retry 3x → Slack alert | ⚪ Pending |
```

---

## Get Started

1. Download `SPECMAP-N8N-INIT.md`
2. Drag into your workflow project folder
3. Tell your AI: "Read SPECMAP-N8N-INIT.md and set up this project"
4. Answer the questions
5. Start building workflows!

**Time to set up: ~5 minutes.**

---

**SpecMap-N8N** - Because your AI should remember which node you were configuring.
