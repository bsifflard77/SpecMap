# Progress: SpecMap + Ralph Integration

**Project**: SpecMap + Ralph Loop Integration
**Started**: 2024-01-14
**Last Updated**: 2025-01-14
**Status**: Phase 1 Implementation Complete - Ready for Testing

---

## Cold Start Briefing

**Current State**: Phase 1 Implementation COMPLETE - all files created.
**Location**: [specs/PHASE-1-SPECIFICATION.md](PHASE-1-SPECIFICATION.md)
**Next Action**: Test the system end-to-end with a real feature

**What We Built**:
- Complete Phase 1 spec (~1,200 lines) covering PRD.md, progress.md, /prd command, ralph.ps1
- Three input modes for /prd: Brain dump, Existing work reference, Hybrid
- Smart iteration limits (5 per story, 50 total)
- Full timestamps on all progress updates

---

## What Was Accomplished

### 1. Analyzed Existing Systems
- Reviewed SpecMap's RULEMAP framework (7 elements with scoring)
- Reviewed Ralph loop (SKILL.md PRD generator + ralph.ps1 autonomous loop)
- Identified integration opportunities and gaps

### 2. Designed Hybrid System (Option C)
Combined the best of both:
- RULEMAP's comprehensive specification approach
- Ralph's "one context window per story" execution model
- SpecMap's save file philosophy (progress.md as heartbeat)

### 3. Key Design Decisions Made

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Token budget | ~350 tokens per iteration | Leaves room for reasoning |
| ID system | Simplified to T, Q, D, B | Avoid over-engineering |
| Question flow | Brain dump first, targeted questions only | More natural UX |
| Iteration limits | 5 per story, 50 total | Prevents stuck loops |
| Timestamps | Full datetime on every update | User requested, aids debugging |
| PRD tracking | Checkboxes in PRD.md | Stories ARE the tracker |
| Git push strategy | Push after story completion + session boundaries | Balance safety vs. noise |

### 4. Created Phase 1 Specification
Complete spec at `specs/PHASE-1-SPECIFICATION.md` covering:
- Section 1: Core Concepts (two-phase model, input modes, save file philosophy)
- Section 2: PRD.md Template (checkbox-based stories, status emojis)
- Section 3: progress.md Template (~300 tokens, Cold Start Briefing, Learnings)
- Section 4: /prd Command (brain dump → analyze → summarize → targeted questions → scope)
- Section 5: ralph.ps1 (smart limits, iteration prompt, exit codes)
- Section 6: End-to-End Examples (three input modes demonstrated)
- Section 7: Error Handling (5 edge cases)
- Section 8: Success Criteria

### 5. Key Updates Made During Review
- Added brain dump / existing work / hybrid input modes (Section 1.2)
- Changed question flow from rigid sequence to "checklist for gaps only"
- Added three detailed examples showing each input mode
- Confirmed PRD.md updates checkboxes in real-time
- Confirmed progress.md tracks exact pickup point with full timestamps

---

## Files Created

| File | Purpose | Status |
|------|---------|--------|
| `specs/PHASE-1-SPECIFICATION.md` | Complete Phase 1 spec | ✅ Complete |
| `specs/SPECMAP-RALPH-PROGRESS.md` | This progress file | ✅ Complete |
| `templates/PRD-TEMPLATE.md` | PRD template with stories | ✅ Complete |
| `templates/progress-TEMPLATE.md` | progress.md template (~300 tokens) | ✅ Complete |
| `scripts/ralph.ps1` | Autonomous execution loop | ✅ Complete |
| `.claude/commands/prd.md` | /prd slash command | ✅ Complete |

---

## What's Next (Testing & Refinement)

Phase 1 implementation is complete. Next steps:

### Testing Checklist
- [ ] Test `/prd` command with brain dump input
- [ ] Test `/prd` command with existing code reference
- [ ] Test `/prd` command with hybrid input
- [ ] Test `ralph.ps1` basic execution
- [ ] Test `ralph.ps1 -Resume` functionality
- [ ] Test `ralph.ps1 -Skip "US-XXX"` functionality
- [ ] Verify git push happens at story completion
- [ ] Verify git push happens on exit
- [ ] Test error handling (stuck scenarios)

### Phase 2 Enhancements (Future)
```
Phase 2: Integration & Polish
├── Package for drop-in use (separate repo?)
├── Bash version of ralph.ps1 for cross-platform
├── More robust error detection
└── Additional examples

Phase 3: Advanced Features
├── CLAUDE.md integration
├── Multi-feature PRD support
└── Analytics/reporting
```

---

## Key Concepts to Remember

### The Two Files Work Together
- **PRD.md** = What needs doing, what's done (checkboxes)
- **progress.md** = Where we are RIGHT NOW, what we learned

### The Flow
```
/prd [brain dump or existing work reference]
  ↓
Claude analyzes, summarizes understanding
  ↓
Claude asks ONLY about gaps
  ↓
Scope options → User picks → PRD draft → Review → Approve
  ↓
Git commit + push (backup PRD to GitHub)
  ↓
ralph.ps1 runs autonomous loop
  ↓
Each iteration: Read progress → Do ONE criterion → Update both files → Commit
  ↓
On story complete: Git push (backup checkpoint)
  ↓
Complete when all [x] or hit limits → Final push
```

### Git Push Points
- **After /prd approval** - Backup PRD.md + progress.md
- **After each story ✅** - Meaningful checkpoint
- **On ralph.ps1 exit** - Whether complete, stuck, or interrupted
- **Before resume** - Pull first to catch changes

### Token Budget
- Cold Start Briefing: ~200 tokens
- Active story: ~150 tokens
- Total per iteration: ~350 tokens (tight!)

### Smart Limits
- 5 attempts per story (prevents stuck loops)
- 50 total iterations (safety cap)
- Same error 3x = stop and ask human

---

## Questions Resolved

- ✅ PRD.md updates checkboxes in real-time as criteria complete
- ✅ progress.md shows exact pickup point (Cold Start Briefing)
- ✅ Full timestamps on all updates (user requirement)
- ✅ Brain dump mode supported (user can describe vision first)
- ✅ Claude analyzes existing code before asking questions
- ✅ Max iterations: 5 per story, 50 total, configurable
- ✅ Git push strategy: Push after /prd approval, after each story ✅, and on ralph.ps1 exit (any reason)
- ✅ Last Push tracked in progress.md Cold Start Briefing
- ✅ Pull before resume to catch external changes

---

## Open Questions

- ❓ Should /prd be a Claude Code slash command or just documented behavior?
- ❓ Cross-platform: Need bash version of ralph.ps1?
- ❓ Where should the drop-in package live? (templates/ or separate repo?)

---

## Resume Instructions

To continue this work:
1. Read this file first
2. Read `specs/PHASE-1-SPECIFICATION.md` for full details
3. Next step: Test the implementation with a real feature
4. Use `/prd [description]` to create a PRD
5. Use `.\scripts\ralph.ps1` to execute autonomously
