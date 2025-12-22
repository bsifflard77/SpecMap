# SpecMap-N8N Project Bootstrap

<!-- 
╔═══════════════════════════════════════════════════════════════════╗
║                        HOW TO USE                                  ║
╠═══════════════════════════════════════════════════════════════════╣
║  1. Drag this file into your new workflow project folder          ║
║  2. Tell your AI agent: "Read SPECMAP-N8N-INIT.md and set up      ║
║     this project"                                                  ║
║  3. Answer the agent's questions                                   ║
║  4. Agent creates all project files                                ║
║  5. This file is deleted when setup is complete                    ║
╚═══════════════════════════════════════════════════════════════════╝

THE MENTAL MODEL:
SpecMap treats AI like a crash-prone process with no memory guarantees.
That's why we use save files, cold start briefings, and integrity checks.

SPECMAP-N8N:
A SpecMap variant optimized for building N8N workflows with AI.
Same philosophy, adapted vocabulary (Workflows, Nodes, Credentials).

VERSION: 1.0.0 (based on SpecMap 3.3.2)
-->

---

## AGENT INSTRUCTIONS

You are initializing a new N8N workflow project with SpecMap-N8N.

**The Mental Model:**
> SpecMap treats AI like a crash-prone process with no memory guarantees.

**SpecMap-N8N Core = 3 files designed as SAVE FILES (not logs):**
- `SPECMAP.md` - Project rules (you read this first, always)
- `workflows.json` - What automations we're building (intent)
- `progress.md` - What's configured, what's next (reality) - **updated after EVERY node**

**The One Rule That Cannot Break:**
> If progress.md isn't updated, SpecMap is broken.
> Every node configured. Every connection made. Every test run. Update progress.md.

**The Save File Philosophy:**
> A brand new agent with zero prior context should be able to read 
> progress.md and continue immediately. Design for cold start.

**Priority Under Pressure:**
> If forced to choose, preserve snapshot over history.
> When in doubt, delete history before touching snapshot sections.

**Follow these steps exactly.**

---

## STEP 1: ASK THESE QUESTIONS

Ask the user each question. Wait for all answers before proceeding.

### Project Basics (Required)
1. What is the project name? (e.g., "Sales Automation Suite", "Customer Onboarding Workflows")
2. Describe what these workflows will accomplish in 2-3 sentences.
3. What is your N8N instance URL? (e.g., https://n8n.yourcompany.com or "local")
4. What N8N version are you running? (e.g., 1.70.0, or "latest" if unsure)

### Connected Services (Required)
5. What external services will these workflows connect to?
   - List each service (e.g., HubSpot, Slack, Gmail, Airtable, Stripe)
   - Note if credentials are already set up in N8N or need to be created

### Workflows (Required)
6. List 2-5 workflows you want to build. For each:
   - Workflow name
   - Trigger type (webhook, schedule, app trigger, manual)
   - One sentence: what it does
   - Priority: high / medium / low

### Optional - Say "skip" or "defaults" to use defaults
7. Any specific error handling strategy? (default: retry 3x then alert)
8. Where should error alerts go? (default: Slack channel or email)
9. Any naming conventions for nodes? (default: descriptive names)

---

## STEP 2: CREATE FILES

After collecting answers, create these files in order:

---

### FILE 1: `.gitignore`

```
# N8N workflow exports (may contain sensitive data)
*.json.bak

# Environment
.env
.env.local

# Snapshots with credentials
snapshots/*-with-creds.json

# IDE
.vscode/
.idea/

# OS
.DS_Store

# SpecMap: DO commit SPECMAP.md, workflows.json, progress.md
# SpecMap: DO commit workflow snapshots (without embedded credentials)
```

---

### FILE 2: `SPECMAP.md`

```markdown
# [PROJECT_NAME]

## The Mental Model

> **SpecMap treats AI like a crash-prone process with no memory guarantees.**
>
> That's why we use save files, cold start briefings, and integrity checks.

---

## What SpecMap-N8N Is NOT

- **Not a workflow manager** → N8N itself handles that
- **Not a version control system** → Use Git for workflow JSON
- **Not an execution monitor** → Use N8N's execution history
- **Not a credential vault** → Use N8N's credential storage

**SpecMap-N8N is a state persistence layer for building workflows with AI.**

### Critical Non-Goal

> **SpecMap-N8N is NOT a substitute for understanding N8N's execution model.**

You still need to understand:
- How data flows between nodes (the `$json` object)
- Expression syntax (`{{ }}` and `$()`)
- How branches and merges work
- Error propagation and handling

SpecMap-N8N tracks *what you've built*. It doesn't teach *how N8N works*.

---

## 🚫 No Silent Node Modifications

> **Do not modify any node marked 🟢 Complete without logging a new decision 
> and updating progress.md first.**

N8N invites casual clicking. AI agents will "just tweak one thing." 
This protects against silent regressions that break downstream nodes.

If a complete node needs changes:
1. Log decision: "D-00X: Modifying [node] because [reason]"
2. Update node status to 🟡 in-progress
3. Make the change
4. Re-test node AND downstream nodes
5. Update progress.md

---

## ⚠️ CRITICAL RULES - READ THIS FIRST

### The One Rule That Cannot Break

> **If progress.md isn't updated, SpecMap is broken.**
> 
> Every node configured. Every connection made. Every test run. Update progress.md.

### The Save File Philosophy

> progress.md is a SAVE FILE, not a log. A brand new agent with zero 
> prior context should be able to read it and continue immediately.

### Priority Under Pressure

> **If forced to choose, preserve snapshot over history.**
> **When in doubt, delete history before touching snapshot sections.**

---

## Before ANY Work

1. Read progress.md completely
2. Check **Last Known Good State** (first paragraph)
3. Run **Snapshot Integrity Check**
4. Check **Resume Confidence** - if < 3, clarify with user first
5. Read the **Cold Start Briefing** in Active Node section
6. Check **Decisions table** for prior node/design choices
7. Continue from where it left off
8. Do NOT reconfigure 🟢 completed nodes

## After EVERY Node Configured

1. Add 🟢 entry to Session Log: `🟢 **HH:MM** - Configured [Node Type] (ID)`
2. Add bullet points: what was configured, expressions used, test results
3. Update **Workflow Status** table
4. Update **Active Node** including Cold Start Briefing
5. Update **Last Known Good State**
6. Update **Resume Confidence**
7. Save progress.md IMMEDIATELY

## When Ending a Session

1. Add `🟡 **HH:MM** - Session ended` entry with:
   - Current active node
   - Current state summary
   - What to do next (resume point)
2. Update **Last Known Good State**
3. Run **Snapshot Integrity Check**
4. Consider saving a workflow snapshot

---

## 🛑 Critical Operations (Require Human Approval)

**STOP and ask before executing any of these:**

- [ ] Activating any workflow in production
- [ ] Deleting any workflow
- [ ] Modifying production credentials
- [ ] Connecting to production databases
- [ ] Sending real emails/messages (first time for each workflow)
- [ ] Making API calls that cost money
- [ ] Modifying shared/team workflows
- [ ] Changing webhook URLs that are already registered

**Protocol:** State what you're about to do, why, and wait for "proceed".

---

## 🔄 Compaction Recovery Protocol

If you notice loss of context, confusion, or uncertainty:

1. **STOP** - Do not guess or continue blindly
2. **READ** progress.md from the top (Last Known Good State)
3. **RUN** Snapshot Integrity Check
4. **READ** the Cold Start Briefing in Active Node
5. **CHECK** the Decisions table for prior node choices
6. **CHECK** Credentials Status table
7. **UPDATE** Resume Confidence (probably 2/5 or lower)
8. **ASK** if confidence < 3: "I may have lost context. Should I proceed with [Active Node] or do you need to brief me?"

**DO NOT:**
- Assume you remember the conversation
- Reconfigure completed nodes (check 🟢 entries)
- Make node choices that contradict the Decisions table
- Execute Critical Operations without re-confirming

---

## 🚫 No Silent Node Modifications

> **Do not modify any node marked 🟢 Complete without logging a new decision 
> and updating progress.md first.**

N8N invites casual clicking. AI agents will "just tweak one thing." 
This protects against silent regressions that break downstream nodes.

**If a complete node needs changes:**
1. Log decision: "D-00X: Modifying [node] because [reason]"
2. Update node status to 🟡 in-progress
3. Make the change
4. Re-test node AND downstream nodes
5. Update progress.md with what changed

---

## N8N MCP Tools (If Available)

| Tool | When to Use |
|------|-------------|
| `search_nodes` | Find the right node type |
| `get_node_documentation` | Understand node parameters |
| `get_node_essentials` | Quick reference for node config |
| `validate_node_operation` | Check config before testing |
| `get_node_for_task` | Get pre-configured templates |
| `validate_workflow` | Validate workflow JSON |

**Before configuring unfamiliar nodes:** Use `get_node_documentation` first.

---

## Adding New Work

| Type | Where to Add | Trigger |
|------|--------------|---------|
| New workflow | workflows.json + Workflow Status table | — |
| New node | workflows.json → nodes array | — |
| Quick idea | Backlog section in progress.md | — |
| Decision | Decisions table in progress.md | "We chose X because..." |

**NEVER create separate node tracking files.**

---

## Source of Truth

| File | Contains | Updates When |
|------|----------|--------------|
| workflows.json | Intent - what workflows should exist | Workflow/node added/completed |
| progress.md | Reality - what's actually configured | **After EVERY node** |

---

## Project Overview

[PROJECT_DESCRIPTION]

---

## N8N Instance

| Property | Value |
|----------|-------|
| URL | [N8N_URL] |
| Version | [N8N_VERSION] |

---

## Error Handling Strategy

**Default Strategy:** [ERROR_STRATEGY]
**Alert Destination:** [ALERT_DESTINATION]

---

## Testing Protocol

### Before Marking Node Complete
- [ ] Node configuration saved in N8N
- [ ] Test execution with sample/mock data
- [ ] Output data structure verified
- [ ] Expressions working correctly

### Before Marking Workflow Complete
- [ ] All nodes configured and tested
- [ ] End-to-end test with real trigger
- [ ] Error handling implemented and tested
- [ ] All acceptance criteria passing

### Before Activating Workflow
- [ ] Workflow complete checklist passed
- [ ] Error workflow connected (if applicable)
- [ ] Stakeholders notified
- [ ] Human approval obtained

---

## VERIFICATION CHECKLIST

Before responding, verify:
- [ ] Did I read progress.md first?
- [ ] Did I check Last Known Good State?
- [ ] Did I run Snapshot Integrity Check?
- [ ] Did I check Resume Confidence?
- [ ] Am I continuing from Active Node, not starting over?
- [ ] After my work, did I update progress.md with timestamp?
- [ ] Did I update the Cold Start Briefing?
- [ ] Are new nodes in workflows.json, not separate files?
- [ ] Did I log any node choice decisions with rationale?
- [ ] Did I ask approval for any Critical Operations?

**If any box is unchecked, fix it before responding.**
```

---

### FILE 3: `workflows.json`

```json
{
  "project": "[PROJECT_NAME]",
  "n8n_version": "[N8N_VERSION]",
  "n8n_url": "[N8N_URL]",
  "created": "[TIMESTAMP]",
  "updated": "[TIMESTAMP]",
  
  "credentials": [
    {
      "service": "[SERVICE_NAME]",
      "name": "[credential-name-in-n8n]",
      "status": "[connected/pending]",
      "tested": false,
      "notes": ""
    }
  ],
  
  "workflows": [
    {
      "id": "001",
      "name": "[WORKFLOW_NAME from Q6]",
      "description": "[WORKFLOW_DESCRIPTION]",
      "priority": "[high/medium/low]",
      "status": "pending",
      "n8n_workflow_id": null,
      
      "trigger": {
        "type": "[webhook/schedule/app-trigger/manual]",
        "details": "[e.g., 'Every day at 9am' or 'On HubSpot contact created']",
        "configured": false
      },
      
      "nodes": [
        {
          "id": "001-N-001",
          "type": "[Trigger Node Type]",
          "action": "[What this node does]",
          "status": "pending",
          "notes": ""
        },
        {
          "id": "001-N-002",
          "type": "[Next Node Type]",
          "action": "[What this node does]",
          "status": "pending",
          "notes": ""
        }
      ],
      
      "connections": [],
      
      "error_handling": {
        "strategy": "[ERROR_STRATEGY]",
        "implemented": false,
        "error_workflow_id": null
      },
      
      "acceptance": [
        {
          "id": "001-A-001",
          "test": "[Testable: Trigger fires when X happens]",
          "passing": false
        },
        {
          "id": "001-A-002",
          "test": "[Testable: Output Y is produced]",
          "passing": false
        }
      ],
      
      "activated": false,
      "completed_at": null
    }
  ],
  
  "backlog": [],
  "decisions": []
}
```

**RULES:**
- 3-8 nodes per workflow (typical)
- 2-4 acceptance criteria per workflow (must be testable)
- IDs: `[WORKFLOW]-N-[NUM]` for nodes, `[WORKFLOW]-A-[NUM]` for acceptance
- Update `n8n_workflow_id` once workflow is created in N8N

---

### FILE 4: `progress.md`

```markdown
# Progress Tracker

> **Last Known Good State ([TIMESTAMP]):**  
> Project initialized with [X] workflows, [Y] total nodes planned. Credentials status: 
> [X connected, Y pending]. Ready to begin Workflow 001 ([FIRST_WORKFLOW_NAME]). 
> No nodes configured yet. No blockers. Resume confidence: 5/5.

**Project:** [PROJECT_NAME]  
**N8N Instance:** [N8N_URL]  
**Last Updated:** [TIMESTAMP]  
**Session:** #1

---

## SNAPSHOT SECTIONS (Sacred - Preserve First)

---

## Resume Confidence

| Check | Value |
|-------|-------|
| **Confidence** | 5/5 |
| **Missing Info** | None |
| **Last Verified** | [TIMESTAMP] |

> If confidence < 3, clarify with user before proceeding.

---

## ✓ Snapshot Integrity Check

Before proceeding, verify:
- [ ] Last Known Good State reflects current reality
- [ ] Active Node matches Workflow Status table
- [ ] Cold Start Briefing is accurate and complete
- [ ] Resume Confidence is set honestly
- [ ] Decisions table includes recent choices
- [ ] Credentials Status is current

> If any box is unchecked, fix it before doing new work.

---

## 📊 Context Budget (Estimated)

| File | Est. Tokens | Status |
|------|-------------|--------|
| SPECMAP.md | ~600 | ✅ Lean |
| workflows.json | ~[ESTIMATE] | ✅ Lean |
| progress.md | ~500 | ✅ Lean |
| **Total Core** | **~[TOTAL]** | ✅ Under 2,000 |

> **Rule:** If Total Core exceeds 2,000 tokens, archive completed work.
> **Priority:** Preserve snapshot sections over history sections.
> **When in doubt:** Delete history before touching snapshot sections.

---

## Credentials Status

| Service | Credential Name | Status | Tested | Notes |
|---------|-----------------|--------|--------|-------|
[GENERATE ROW FOR EACH CREDENTIAL FROM Q5]

---

## 🟡 Active Node

| Field | Value |
|-------|-------|
| **Node** | [First node - likely trigger] |
| **ID** | 001-N-001 |
| **Workflow** | 001 - [FIRST_WORKFLOW_NAME] |
| **Started** | [TIMESTAMP] |

### Cold Start Briefing

**What:** Configuring [NODE_TYPE] node to [what it does].

**Why:** First node of Workflow 001 ([WORKFLOW_NAME]). This workflow [brief description]. This is the trigger node - everything else depends on it.

**Where:** N8N workflow editor → Create new workflow → Add [NODE_TYPE] node

**Current State:** Workflow not yet created in N8N. Starting fresh.

**Upstream Data:** None (this is the trigger)

**Next Step:** 
1. Create new workflow in N8N named "[WORKFLOW_NAME]"
2. Add [NODE_TYPE] trigger node
3. Configure trigger settings: [specific settings needed]
4. Test trigger fires correctly

**Blockers:** [Any credential or access issues, or "None"]

**Decision Context:** None yet - first node.

---

## Workflow Status

| ID | Workflow | Nodes | Status | Tested | Activated |
|----|----------|-------|--------|--------|-----------|
| 001 | [Name] | 0/[X] | ⚪ | — | — |
| 002 | [Name] | 0/[X] | ⚪ | — | — |
[GENERATE FOR EACH WORKFLOW]

**Legend:** 🟢 Complete | 🟡 Active | ⚪ Pending | 🔴 Blocked

---

## Decisions

> **Trigger:** Any time you choose a node type, design pattern, or error handling approach → log it here.
> **Requirement:** Include alternatives considered and why this choice was made.

| ID | Decision | Rationale (Alternatives Considered) | Date |
|----|----------|-------------------------------------|------|
| | (none yet) | | |

---

## Workflow Snapshots

> **Save snapshots after structural milestones, not cosmetic changes.**

| Workflow | Version | Nodes | Status | File | Date |
|----------|---------|-------|--------|------|------|
| | (none yet) | | | | |

**When to snapshot:**
- ✅ After trigger complete and tested
- ✅ After happy path complete (all nodes working end-to-end)
- ✅ After error handling added
- ✅ Before activating in production

**When NOT to snapshot:**
- ❌ After renaming nodes or cosmetic changes
- ❌ After minor expression tweaks

---

## HISTORY SECTIONS (Archive First When Needed)

---

## Session Log

### [TODAY'S DATE]

#### Session 1 (Started: [TIME])

🟢 **[TIME]** - Initialized project with SpecMap-N8N
   - Created SPECMAP.md with N8N-specific rules
   - Created workflows.json with [X] workflows, [Y] nodes planned
   - Created progress.md with Cold Start Briefing
   - Credentials status: [summary]
   - Ready to begin Workflow 001: [WORKFLOW_NAME]

---

## Backlog

| Added | Item | Priority | Notes |
|-------|------|----------|-------|
| | (none yet) | | |

---

## Questions

| ID | Question | Blocking | Status |
|----|----------|----------|--------|
| | (none yet) | | |

---

## Blockers

| ID | Blocker | Impact | Status |
|----|---------|--------|--------|
| | (none) | | |

---

## Resume Instructions

```
THE MENTAL MODEL:
SpecMap treats AI like a crash-prone process with no memory guarantees.

FOR ANY AGENT (including after context compaction):

1. READ the "Last Known Good State" at the top of this file
2. RUN Snapshot Integrity Check - fix any issues before proceeding
3. CHECK Resume Confidence - if < 3, ask user for clarification
4. CHECK Credentials Status - know what's connected
5. READ the Cold Start Briefing in the Active Node section
6. CHECK the Decisions table for prior node choices
7. SCAN Session Log for recent 🟢 entries (don't reconfigure these)
8. CONTINUE from where the Cold Start Briefing indicates

AFTER EVERY NODE CONFIGURED:
1. Add: 🟢 **HH:MM** - Configured [Node Type] (ID)
2. Add bullet points: settings, expressions, test results
3. Update the Cold Start Briefing for the next node
4. Update Last Known Good State
5. Update Workflow Status table
6. Update Resume Confidence  
7. Save IMMEDIATELY

WHEN ENDING A SESSION:
1. Add: 🟡 **HH:MM** - Session ended
   - Active: [current node]
   - State: [what's configured, what's next]
   - Resume: [specific next step]
2. Consider saving a workflow snapshot
3. Run Snapshot Integrity Check

DECISION TRIGGER:
• Any node choice, design pattern, or error handling → Decisions table
• Include: what was chosen, alternatives considered, why

CRITICAL OPERATIONS:
• Check SPECMAP.md for operations requiring human approval
• STOP and ASK before: activating, deleting, production credentials

ARCHIVE HIERARCHY:
KEEP (Sacred):              DELETE FIRST (History):
─────────────────────       ─────────────────────
Last Known Good State       Old session log entries
Credentials Status          Completed workflow snapshots
Active Node + Cold Start    Old test results
Workflow Status table       
Recent Decisions            
```
```

---

### FILE 5: Create `snapshots/` directory

```bash
mkdir -p snapshots
echo "# Workflow Snapshots\n\nSave workflow JSON exports here after major milestones." > snapshots/README.md
```

---

## STEP 3: INITIALIZE GIT

```bash
git init
git add .
git commit -m "chore: Initialize project with SpecMap-N8N"
```

---

## STEP 4: DELETE THIS FILE

```bash
rm SPECMAP-N8N-INIT.md
git add -A && git commit -m "chore: Remove bootstrap file"
```

---

## STEP 5: REPORT TO USER

```
═══════════════════════════════════════════════════════════════════
✅ SpecMap-N8N Setup Complete
═══════════════════════════════════════════════════════════════════

🧠 Mental Model:
   SpecMap treats AI like a crash-prone process with no memory guarantees.
   That's why we use save files, cold start briefings, and integrity checks.

📁 Core Files Created:
   • SPECMAP.md        - N8N-specific rules + Critical Operations
   • workflows.json    - [X] workflows, [Y] nodes planned
   • progress.md       - Save file with Cold Start Briefing
   • snapshots/        - Directory for workflow JSON exports

📋 Workflows Ready:
   001 [Workflow 1] - [priority] - [trigger type] - [X nodes]
   002 [Workflow 2] - [priority] - [trigger type] - [X nodes]
   ...

🔑 Credentials Status:
   [Service 1] - [connected/pending]
   [Service 2] - [connected/pending]
   ...

📊 Context Budget:
   SPECMAP.md:       ~600 tokens
   workflows.json:   ~[X] tokens
   progress.md:      ~500 tokens
   Total:            ~[Y] tokens ✅ Under 2,000

🚀 Next Steps:
   1. Verify/connect any pending credentials in N8N
   2. I'll begin with: 001-N-001 - [First node description]
   3. We'll build and test each node before moving to the next

💡 How This Works:
   • I read progress.md at the start of every session
   • I update progress.md after every node configured
   • The Cold Start Briefing includes upstream data structure
   • You can step away, switch agents, or recover from compaction seamlessly

⚠️  The One Rule:
   If progress.md isn't updated, SpecMap is broken.
   Every node. Every connection. Every test.

🛑 Critical Operations (I'll ask first):
   • Activating workflows
   • Deleting workflows
   • Production credentials
   • Sending real messages/emails

═══════════════════════════════════════════════════════════════════
```

---

## FINAL CHECKLIST

Before reporting completion:

- [ ] Asked questions 1-6 (required) and 7-9 (optional)
- [ ] Created .gitignore protecting sensitive files
- [ ] Created SPECMAP.md with:
  - [ ] Mental Model statement
  - [ ] What SpecMap-N8N Is NOT section
  - [ ] N8N-specific Critical Operations
  - [ ] Compaction Recovery Protocol
  - [ ] N8N MCP Tools reference (if applicable)
  - [ ] Testing Protocol checklists
  - [ ] Verification Checklist
- [ ] Created workflows.json with:
  - [ ] All workflows from Q6
  - [ ] Credentials list from Q5
  - [ ] Trigger types specified
  - [ ] Initial node breakdown (2-5 nodes per workflow)
  - [ ] Acceptance criteria for each workflow
- [ ] Created progress.md with:
  - [ ] SNAPSHOT SECTIONS header
  - [ ] HISTORY SECTIONS header
  - [ ] Last Known Good State
  - [ ] Credentials Status table
  - [ ] Cold Start Briefing with upstream data section
  - [ ] Workflow Status table
  - [ ] Decisions table
  - [ ] Workflow Snapshots table
  - [ ] Resume Instructions with N8N-specific guidance
- [ ] Created snapshots/ directory
- [ ] Initialized git with commit
- [ ] Deleted this SPECMAP-N8N-INIT.md file
- [ ] Reported summary with credentials status

**Setup complete when all boxes checked.**

---

## N8N NODE TYPES REFERENCE

Common node categories for workflow planning:

### Triggers
- **Webhook** - Receive HTTP requests
- **Schedule** - Time-based (cron)
- **App Triggers** - HubSpot, Slack, Stripe, etc.
- **Manual** - Triggered by user

### Core Nodes
- **IF** - Conditional branching
- **Switch** - Multiple branches
- **Merge** - Combine branches
- **Set** - Transform data
- **Code** - Custom JavaScript

### Common Integrations
- **HTTP Request** - Call any API
- **Slack** - Messages, channels
- **Gmail/Email** - Send emails
- **Google Sheets** - Read/write data
- **Airtable** - Database operations
- **HubSpot/Salesforce** - CRM operations

### Error Handling
- **Error Trigger** - Catch workflow errors
- **Stop and Error** - Intentionally fail
- **No Operation** - Placeholder

---

**SpecMap-N8N** - Because your AI should remember which node you were configuring.
