# SpecMap-N8N

## AI-Powered N8N Workflow Development

**One file. Any AI agent. Perfect resumability. Compaction-proof.**

*A SpecMap variant optimized for building N8N automations.*

---

## Why SpecMap-N8N Exists

> **AI doesn't forget—it evaporates.**
>
> SpecMap-N8N turns ephemeral AI sessions into a durable, resumable workflow-building memory that survives context compaction, session breaks, and even switching AI agents entirely.

### The Mental Model

> **SpecMap treats AI like a crash-prone process with no memory guarantees.**

Building complex N8N workflows with AI often spans multiple sessions. Without externalized state:
- The agent forgets which nodes are configured
- Decisions about node choices are lost
- Error handling strategies are forgotten
- You re-explain the same context repeatedly

SpecMap-N8N solves this.

---

## What SpecMap-N8N Is NOT

| SpecMap-N8N is NOT... | Use instead... |
|-----------------------|----------------|
| A workflow manager | N8N itself |
| A version control system | Git (for workflow JSON) |
| An execution monitor | N8N execution history |
| A credential vault | N8N credential storage |
| A node library | N8N's built-in nodes |

**SpecMap-N8N is a state persistence layer for building workflows with AI.**

### Critical Non-Goal

> **SpecMap-N8N is NOT a substitute for understanding N8N's execution model.**

You still need to understand:
- How data flows between nodes (the `$json` object)
- Expression syntax (`{{ }}` and `$()`)  
- How branches and merges work
- Error propagation and handling
- Execution order and parallelism

SpecMap-N8N tracks *what you've built*. It doesn't teach *how N8N works*.

---

## Quick Start

### Step 1: Download

Download `SPECMAP-N8N-INIT.md` from this repository.

### Step 2: Initialize

1. Create a new folder for your workflow project
2. Drag `SPECMAP-N8N-INIT.md` into the folder
3. Open your AI tool (Claude Code, Cursor, etc.)
4. Tell the agent: **"Read SPECMAP-N8N-INIT.md and set up this project"**

### Step 3: Answer Questions

The agent will ask you about:
- Project name and description
- N8N instance details (version, URL)
- Connected services and credentials needed
- Workflows you want to build (2-5 workflows)
- Trigger types and general flow

### Step 4: Start Building

The agent creates your files and you're ready to build workflows.

---

## The Three Core Files

```
your-workflow-project/
├── SPECMAP.md        # Rules (agent reads this first)
├── workflows.json    # Intent (what automations we're building)
└── progress.md       # Reality (what's configured, what's next)
```

### Source of Truth

| File | Contains | Purpose | Updates When |
|------|----------|---------|--------------|
| **SPECMAP.md** | Rules | How to work + N8N-specific guidance | Rarely (setup) |
| **workflows.json** | Intent | Workflows, nodes, acceptance criteria | Workflow/node added or completed |
| **progress.md** | Reality | Current state, active node, decisions | **After EVERY node configured** |

---

## The One Rule That Cannot Break

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   If progress.md isn't updated, SpecMap is broken.              │
│                                                                 │
│   Every node configured. Every connection made.                 │
│   Every test run. Update progress.md.                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🚫 No Silent Node Modifications

> **Do not modify any node marked 🟢 Complete without logging a new decision and updating progress.md first.**

N8N invites casual clicking. AI agents will "just tweak one thing." This protects against silent regressions that break downstream nodes.

**If a complete node needs changes:**
1. Log a decision: "D-00X: Modifying 001-N-002 because [reason]"
2. Update node status to 🟡 in-progress  
3. Make the change
4. Re-test the node AND downstream nodes
5. Update progress.md with what changed

---

## N8N-Specific Tracking

### workflows.json Structure

```json
{
  "project": "Sales Automation Suite",
  "n8n_version": "1.70.0",
  "n8n_url": "https://n8n.yourcompany.com",
  "created": "2025-12-22",
  "updated": "2025-12-22",
  
  "credentials": [
    { "service": "HubSpot", "name": "hubspot-prod", "status": "connected", "tested": true },
    { "service": "Slack", "name": "slack-workspace", "status": "connected", "tested": false },
    { "service": "Gmail", "name": "gmail-notifications", "status": "pending", "tested": false }
  ],
  
  "workflows": [
    {
      "id": "001",
      "name": "New Lead Notification",
      "description": "When HubSpot contact created, notify Slack + send welcome email",
      "status": "in-progress",
      "n8n_workflow_id": null,
      
      "trigger": {
        "type": "HubSpot Trigger",
        "event": "contact.created",
        "configured": true
      },
      
      "nodes": [
        { 
          "id": "001-N-001", 
          "type": "HubSpot Trigger", 
          "action": "On contact created",
          "status": "complete",
          "notes": "Webhook URL registered in HubSpot"
        },
        { 
          "id": "001-N-002", 
          "type": "IF", 
          "action": "Check if email exists",
          "status": "complete",
          "notes": "Filters out contacts without email"
        },
        { 
          "id": "001-N-003", 
          "type": "Slack", 
          "action": "Send message to #sales",
          "status": "in-progress",
          "notes": "Channel selected, message template pending"
        },
        { 
          "id": "001-N-004", 
          "type": "Gmail", 
          "action": "Send welcome email",
          "status": "pending",
          "notes": ""
        }
      ],
      
      "connections": [
        { "from": "001-N-001", "to": "001-N-002" },
        { "from": "001-N-002", "to": "001-N-003", "branch": "true" },
        { "from": "001-N-003", "to": "001-N-004" }
      ],
      
      "error_handling": {
        "strategy": "Retry 3x then Slack alert",
        "implemented": false,
        "error_workflow_id": null
      },
      
      "acceptance": [
        { "id": "001-A-001", "test": "New HubSpot contact triggers workflow", "passing": false },
        { "id": "001-A-002", "test": "Slack message contains contact name and source", "passing": false },
        { "id": "001-A-003", "test": "Welcome email sent with correct template", "passing": false },
        { "id": "001-A-004", "test": "Error handling triggers on API failure", "passing": false }
      ],
      
      "activated": false,
      "completed_at": null
    }
  ],
  
  "backlog": [],
  "decisions": []
}
```

### Node Status Tracking

| Status | Meaning |
|--------|---------|
| `pending` | Not yet configured |
| `in-progress` | Currently being configured |
| `complete` | Configured and tested individually |
| `blocked` | Waiting on credential or upstream node |

### Credential Status

```markdown
## Credentials Status

| Service | Credential Name | Status | Tested | Notes |
|---------|-----------------|--------|--------|-------|
| HubSpot | hubspot-prod | ✅ Connected | ✅ | API key in N8N |
| Slack | slack-workspace | ✅ Connected | ⚪ | OAuth complete |
| Gmail | gmail-notifications | ⚪ Pending | — | Needs OAuth setup |
```

### Error Handling Tracking

```markdown
## Error Handling Status

| Workflow | Strategy | Implemented | Tested |
|----------|----------|-------------|--------|
| 001 | Retry 3x → Slack alert to #errors | ⚪ Pending | — |
| 002 | Log to Airtable + email admin | ⚪ Pending | — |
```

---

## Cold Start Briefing (N8N Adapted)

Every Active Node includes complete context:

```markdown
## 🟡 Active Node

| Field | Value |
|-------|-------|
| **Node** | Slack - Send message |
| **ID** | 001-N-003 |
| **Workflow** | 001 - New Lead Notification |
| **Started** | 14:35 |

### Cold Start Briefing

**What:** Configuring Slack node to send new lead notifications to #sales channel.

**Why:** Part of Workflow 001 (New Lead Notification). Upstream nodes complete:
- 001-N-001 (HubSpot Trigger) ✅ - receiving webhooks
- 001-N-002 (IF node) ✅ - filtering contacts with email

**Where:** N8N workflow editor → Slack node (3rd node in chain)

**Current State:** 
- Slack credential connected and tested
- Channel selected: #sales
- Message template needed

**Data Available from Upstream:**
```json
{
  "properties": {
    "firstname": "John",
    "lastname": "Doe", 
    "email": "john@example.com",
    "source": "Website Form"
  }
}
```

**Next Step:** Configure message template:
```
🆕 New Lead: {{ $json.properties.firstname }} {{ $json.properties.lastname }}
📧 Email: {{ $json.properties.email }}
📍 Source: {{ $json.properties.source }}
```

**Blockers:** None.

**Decision Context:** 
- D-001: Using #sales channel (not DMs) for team visibility
- D-002: Include source field to track lead origin
```

---

## Decisions Table (N8N Specific)

N8N workflows involve many decisions. Capture them:

```markdown
## Decisions

| ID | Decision | Rationale (Alternatives Considered) | Date |
|----|----------|-------------------------------------|------|
| D-001 | Post to #sales channel | Team visibility more important than individual notification. **Considered:** DM to assigned rep—rejected, need team awareness. | 2025-12-22 |
| D-002 | Use HubSpot Trigger (webhook) | Real-time notification required. **Considered:** Schedule node polling every 5 min—rejected, too slow for sales follow-up. | 2025-12-22 |
| D-003 | Include source field in Slack message | Sales needs to know lead origin for context. **Considered:** Minimal message—rejected, missing key info. | 2025-12-22 |
| D-004 | Retry 3x before error alert | Balance between resilience and alert fatigue. **Considered:** Immediate alert—rejected, too noisy for transient failures. | 2025-12-22 |
| D-005 | Use IF node to filter missing emails | Prevent downstream errors. **Considered:** Let it fail—rejected, creates noise in error logs. | 2025-12-22 |
```

---

## N8N MCP Tools Integration

If you have N8N MCP tools available, reference them:

```markdown
## N8N MCP Tools Available

| Tool | When to Use |
|------|-------------|
| `search_nodes` | Find the right node type for a task |
| `get_node_documentation` | Understand node parameters and options |
| `get_node_essentials` | Quick reference for node configuration |
| `validate_node_operation` | Check if node config is valid before testing |
| `get_node_for_task` | Get pre-configured node templates |
| `list_node_templates` | Find example workflows using specific nodes |
| `validate_workflow` | Validate entire workflow JSON structure |

**Before configuring any unfamiliar node:** 
Use `get_node_documentation` to understand all available options.
```

---

## Workflow Snapshots

Save workflow JSON after significant milestones:

```markdown
## Workflow Snapshots

| Workflow | Version | Nodes | Status | File | Date |
|----------|---------|-------|--------|------|------|
| 001 - New Lead Notification | v0.1 | 2/5 | Draft | `snapshots/001-v0.1.json` | 2025-12-22 |
| 001 - New Lead Notification | v0.2 | 4/5 | Draft | `snapshots/001-v0.2.json` | 2025-12-22 |
```

### When to Snapshot

> **Save snapshots after structural milestones, not cosmetic changes.**

**✅ Do snapshot after:**
- Trigger node complete and tested
- Happy path complete (all nodes connected, working end-to-end)
- Error handling added
- Before activating in production

**❌ Don't snapshot after:**
- Renaming a node
- Adjusting message formatting
- Minor expression tweaks
- Cosmetic reorganization

This prevents snapshot spam and keeps them meaningful for rollback.

---

## Testing Checklist

### Before Marking Node Complete
- [ ] Node configuration saved
- [ ] Test execution with sample data
- [ ] Output data structure verified
- [ ] Expressions working correctly
- [ ] Error cases considered

### Before Marking Workflow Complete
- [ ] All nodes configured and tested individually
- [ ] End-to-end test with real trigger
- [ ] Happy path executes successfully
- [ ] Error handling tested
- [ ] All acceptance criteria passing
- [ ] No hardcoded values (use expressions or env vars)
- [ ] Execution time acceptable
- [ ] Credentials using production values

### Before Activating Workflow
- [ ] Workflow complete checklist passed
- [ ] Error workflow connected (if applicable)
- [ ] Monitoring/alerting in place
- [ ] Stakeholders notified
- [ ] Rollback plan documented

---

## Critical Operations (Human Approval Required)

```markdown
## 🛑 Critical Operations

Pause and ask before:
- [ ] Activating workflow in production
- [ ] Deleting any workflow
- [ ] Modifying production credentials
- [ ] Connecting to production databases
- [ ] Sending real emails/messages (first time)
- [ ] Making API calls that cost money
- [ ] Modifying shared/team workflows
```

---

## Progress Entry Format (N8N)

```markdown
🟢 **14:35** - Configured Slack node (001-N-003)
   - Connected to #sales channel
   - Message template: New lead with name, email, source
   - Used expressions for dynamic content
   - Tested with mock HubSpot data - working
   - Next: Gmail node (001-N-004)

🟢 **15:10** - Configured Gmail node (001-N-004)
   - Template: welcome-new-lead
   - Dynamic subject with contact name
   - Tested send to test email - received correctly
   - Next: Error handling setup

🟡 **16:00** - Session ended
   - Active: Error handling for Workflow 001
   - State: All 4 nodes configured and tested individually
   - Resume: Add Error Trigger workflow, connect to main workflow
```

---

## Workflow Status Summary

```markdown
## Workflow Status

| ID | Workflow | Nodes | Status | Tested | Activated |
|----|----------|-------|--------|--------|-----------|
| 001 | New Lead Notification | 4/4 | 🟢 Complete | ✅ E2E | ⚪ No |
| 002 | Daily Sales Report | 0/6 | ⚪ Pending | — | — |
| 003 | Customer Feedback Loop | 2/5 | 🟡 Active | ⚪ Partial | — |

**Legend:** 🟢 Complete | 🟡 Active | ⚪ Pending | 🔴 Blocked
```

---

## Archive Hierarchy

When context budget is tight:

```
KEEP (Sacred):                      DELETE FIRST (History):
────────────────────────────────    ────────────────────────
Last Known Good State               Old session log entries
Cold Start Briefing                 Resolved questions
Active Node details                 Completed workflow snapshots
Credentials Status                  Old test results
Recent Decisions                    
Workflow Status table               

⚠️ When in doubt, delete history before touching snapshot sections.
```

---

## ID System

| ID | Meaning |
|----|---------|
| `001` | Workflow 001 |
| `001-N-001` | Node 1 of Workflow 001 |
| `001-A-001` | Acceptance criterion 1 of Workflow 001 |
| `D-001` | Decision 1 |
| `Q-001` | Question 1 |
| `B-001` | Blocker 1 |

---

## Best Practices

### DO ✅

- Update `progress.md` after every node configured
- Run Snapshot Integrity Check before resuming
- Test each node individually before connecting
- Save workflow snapshots at milestones
- Document node expressions in Cold Start Briefing
- Log all node choice decisions with rationale
- Test error handling before activating

### DON'T ❌

- Activate workflows without end-to-end testing
- Skip credential testing
- Hardcode values that should be dynamic
- Configure multiple nodes without updating progress
- Delete workflow JSON without backup
- Assume AI remembers upstream node data structure

---

## Troubleshooting

### Agent forgot which node we were configuring?

"Read progress.md and continue from the Cold Start Briefing."

### Agent doesn't know what data is available from upstream?

Cold Start Briefing should include "Data Available from Upstream" section.

### Agent using wrong expressions?

Check the upstream node output structure. Use N8N's expression editor to verify.

### Workflow not triggering?

1. Check trigger node configuration
2. Verify webhook URL is registered (for webhook triggers)
3. Check N8N execution history for errors
4. Verify credentials are connected and tested

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-12 | Initial SpecMap-N8N release |

---

## Get Started

1. Download `SPECMAP-N8N-INIT.md`
2. Drag into your workflow project folder
3. Tell your AI: "Read SPECMAP-N8N-INIT.md and set up this project"
4. Answer the questions
5. Start building workflows!

---

**SpecMap-N8N** - Because your AI should remember which node you were configuring.

*Built on SpecMap 3.3.2 - Plan. Build. Track. Ship.*
