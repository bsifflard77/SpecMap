# Track Command

Update and view project progress tracking.

## Usage

```
/track                    # Show current status
/track status             # Detailed status report
/track update [id] [status]  # Update item status
/track report             # Generate progress report
```

## Status Values

| Status | Emoji | Meaning |
|--------|-------|---------|
| Pending | ⏳ | Not started |
| In Progress | 🔄 | Currently working |
| Blocked | ⛔ | Waiting on dependency |
| Complete | ✅ | Finished |

## Quick Status View

```markdown
## Project Status: [Project Name]
**Last Updated**: [Timestamp]

### Active Features
| Feature | Status | Progress | Blockers |
|---------|--------|----------|----------|
| 001-F | Implementation | 65% | None |
| 002-F | Planning | 20% | 002-Q-003 |

### Today's Focus
- 🔄 001-T-042: Implement password validation
- ⏳ 001-T-043: Add unit tests

### Blockers
- ⛔ 002-T-015: Waiting on 002-D-003 (OAuth decision)
```

## Progress Update Format

After every action, add to progress.md:

```markdown
## [DATE]

### Completed
- ✅ [001-T-042]: Implemented password validation (2.5h)
- ✅ [001-T-043]: Added unit tests for auth service (1.5h)

### In Progress
- 🔄 [001-T-044]: OAuth integration - 60% complete

### Blocked
- ⛔ [001-T-050]: Session management - waiting on 001-D-005

### Decisions Made
- [001-D-005]: Using Redis for session storage (approved)

### Questions Resolved
- [001-Q-012]: Token refresh policy - 24h with sliding window

### Next Session
1. Complete 001-T-044 (OAuth)
2. Start 001-T-045 (JWT implementation)
3. Resolve 001-Q-015 (rate limiting)
```

## Tracking Dashboard

Generate comprehensive tracking:

```markdown
# Feature Tracking: 001-user-authentication

## Summary
| Metric | Count | % |
|--------|-------|---|
| Total Tasks | 25 | 100% |
| Complete | 15 | 60% |
| In Progress | 3 | 12% |
| Blocked | 1 | 4% |
| Pending | 6 | 24% |

## By Phase
| Phase | Tasks | Complete | Status |
|-------|-------|----------|--------|
| Phase 1: Foundation | 8 | 8 | ✅ Done |
| Phase 2: Core Auth | 10 | 7 | 🔄 Active |
| Phase 3: Integration | 7 | 0 | ⏳ Pending |

## Open Items
### Questions (2 open)
- [001-Q-015]: Rate limiting strategy? (P1)
- [001-Q-016]: Password policy details? (P2)

### Decisions (1 pending)
- [001-D-006]: Caching strategy - needs review

### Issues (1 active)
- [001-I-002]: Performance concern with bcrypt rounds
```

## Reports

### Daily Standup Report
```
/track report daily
```

Generates:
- Yesterday's completed items
- Today's focus
- Current blockers
- Help needed

### Weekly Summary Report
```
/track report weekly
```

Generates:
- Week's accomplishments
- Velocity metrics
- Risk assessment
- Next week's priorities

### Feature Completion Report
```
/track report feature [id]
```

Generates:
- All tasks and their status
- Timeline vs actual
- Decisions made
- Lessons learned

## Output Files

- `progress.md` - Updated with new entries
- `01-specifications/[###]-[feature]/TRACKING.md` - Feature-specific tracking
- Generated reports saved to `reports/` directory

## Best Practices

1. **Update immediately** - Log work as you complete it
2. **Be specific** - Include durations, blockers, decisions
3. **Flag early** - Report blockers as soon as identified
4. **Plan ahead** - Note next actions for continuity
