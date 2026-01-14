# Progress: SpecMap + Ralph Integration

**Project**: SpecMap + Ralph Loop Integration
**Started**: 2024-01-14
**Last Updated**: 2025-01-14
**Status**: Phase 1 Complete - Pushed to GitHub

---

## Cold Start Briefing

> Read this first if starting a new session.

**Current State**: Phase 1 COMPLETE. All files created, drop-in package ready, pushed to GitHub.

**What Exists**:
- Specification: [specs/PHASE-1-SPECIFICATION.md](PHASE-1-SPECIFICATION.md)
- Drop-in package: `specmap-ralph/` (copy to any project)
- Active commands: `/prd` slash command ready to use
- Execution script: `scripts/ralph.ps1`

**GitHub**: https://github.com/bsifflard77/SpecMap.git

**Next Action**: Test the system with a real feature, or use it in another project.

**To Use Now**:
```
/prd [describe your feature idea]
```

Then run:
```powershell
.\scripts\ralph.ps1
```

---

## Project Structure

```
SpecMap/
├── .claude/commands/prd.md     # /prd slash command (active)
├── scripts/ralph.ps1           # Autonomous execution loop
├── templates/                  # Templates for this project
│   ├── PRD-TEMPLATE.md
│   └── progress-TEMPLATE.md
├── specs/                      # Design documentation
│   ├── PHASE-1-SPECIFICATION.md
│   └── SPECMAP-RALPH-PROGRESS.md (this file)
└── specmap-ralph/              # DROP-IN PACKAGE (copy to other projects)
    ├── README.md
    ├── .claude/commands/prd.md
    ├── scripts/ralph.ps1
    └── templates/
        ├── PRD-TEMPLATE.md
        └── progress-TEMPLATE.md
```

---

## Files Created

| File | Purpose | Status |
|------|---------|--------|
| `specs/PHASE-1-SPECIFICATION.md` | Complete Phase 1 spec (~1,600 lines) | ✅ Complete |
| `specs/SPECMAP-RALPH-PROGRESS.md` | This progress file | ✅ Complete |
| `templates/PRD-TEMPLATE.md` | PRD template with stories | ✅ Complete |
| `templates/progress-TEMPLATE.md` | progress.md template (~300 tokens) | ✅ Complete |
| `scripts/ralph.ps1` | Autonomous execution loop | ✅ Complete |
| `.claude/commands/prd.md` | /prd slash command | ✅ Complete |
| `specmap-ralph/` | Drop-in package for other projects | ✅ Complete |

---

## Key Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Token budget | ~350 tokens per iteration | Leaves room for reasoning |
| Question flow | Brain dump first, targeted questions only | More natural UX |
| Iteration limits | 5 per story, 50 total | Prevents stuck loops |
| Timestamps | Full datetime on every update | Aids debugging |
| PRD tracking | Checkboxes in PRD.md | Stories ARE the tracker |
| Git push strategy | Push after story completion + session boundaries | Balance safety vs. noise |
| Drop-in package | `specmap-ralph/` folder | Easy adoption in any project |

---

## How It Works

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
- **After each story complete** - Meaningful checkpoint
- **On ralph.ps1 exit** - Whether complete, stuck, or interrupted
- **Before resume** - Pull first to catch changes

### Smart Limits
- 5 attempts per story (prevents stuck loops)
- 50 total iterations (safety cap)
- Same error 3x = stop and ask human

---

## What's Next

### Testing Checklist
- [ ] Test `/prd` command with brain dump input
- [ ] Test `/prd` command with existing code reference
- [ ] Test `/prd` command with hybrid input
- [ ] Test `ralph.ps1` basic execution
- [ ] Test `ralph.ps1 -Resume` functionality
- [ ] Verify git push happens at story completion

### Future Enhancements
- Bash version of ralph.ps1 for cross-platform support
- More robust error detection in loop
- CLAUDE.md integration for project-specific rules
- Analytics/reporting on execution patterns

---

## Questions Resolved

- ✅ PRD.md updates checkboxes in real-time as criteria complete
- ✅ progress.md shows exact pickup point (Cold Start Briefing)
- ✅ Full timestamps on all updates
- ✅ Brain dump mode supported
- ✅ Claude analyzes existing code before asking questions
- ✅ Max iterations: 5 per story, 50 total, configurable
- ✅ Git push strategy defined and implemented
- ✅ Drop-in package created: `specmap-ralph/`
- ✅ /prd implemented as Claude Code slash command

---

## Resume Instructions

**To continue development on SpecMap+Ralph**:
1. Read this file first
2. Read `specs/PHASE-1-SPECIFICATION.md` for full details
3. Test with a real feature or enhance the system

**To use in this project**:
```
/prd [describe your feature]
.\scripts\ralph.ps1
```

**To use in another project**:
1. Copy `specmap-ralph/` folder to the project
2. Run `/prd [description]`
3. Run `.\scripts\ralph.ps1`
