# SpecMap Skills & Platform Integration

Complete AI skills package for specification-driven development across multiple platforms.

## Overview

SpecMap provides native integrations for:
- **Claude Code / Claude.ai** - Skills, slash commands, MCP
- **ChatGPT** - Custom GPTs with knowledge files
- **Google Gemini** - Gems and CLI extensions

## Directory Structure

```
specmap/
├── skills/                    # Claude Skills (Phase 1)
│   ├── specmap-core/          # Core workflow skill
│   ├── specmap-documents/     # Document generation skill
│   └── specmap-agents/        # Agent orchestration skill
│
├── platforms/                 # Platform-specific integrations
│   ├── claude/                # Claude Code integration
│   │   ├── .claude/commands/  # Slash commands
│   │   └── CLAUDE.md          # Project instructions
│   │
│   ├── chatgpt/               # ChatGPT integration
│   │   ├── gpts/              # Custom GPT definitions
│   │   └── knowledge/         # Knowledge files for GPTs
│   │
│   └── gemini/                # Gemini integration
│       ├── gems/              # Gem definitions
│       └── extensions/        # CLI extension config
│
└── docs/                      # Documentation
    ├── SKILLS-GUIDE.md        # How to use skills
    ├── PLATFORM-SETUP.md      # Platform-specific setup
    └── ARCHITECTURE.md        # Technical architecture
```

## Quick Start

### For Claude Code Users

1. Copy the `skills/` folder to your project or `~/.claude/skills/`
2. Copy `platforms/claude/.claude/` to your project root
3. Use slash commands: `/specify`, `/clarify`, `/plan`, `/tasks`

### For ChatGPT Users

1. Create Custom GPTs using definitions in `platforms/chatgpt/gpts/`
2. Upload knowledge files from `platforms/chatgpt/knowledge/`
3. Use the GPTs for PRD generation, task planning, etc.

### For Gemini Users

1. Create Gems using definitions in `platforms/gemini/gems/`
2. Install CLI extension from `platforms/gemini/extensions/`
3. Use `gemini specmap` commands

## Skills Overview

| Skill | Purpose | Triggers |
|-------|---------|----------|
| specmap-core | Workflow management | specmap, PRD, specification |
| specmap-documents | Document generation | export, dashboard, Word, Excel |
| specmap-agents | Multi-agent orchestration | agent, handoff, orchestrate |

## Version

- **Version**: 1.0.0
- **Date**: 2025-12-23
- **Status**: Phase 1 Complete

## Roadmap

- [x] Phase 1: Claude Skills
- [ ] Phase 2: ChatGPT Custom GPTs
- [ ] Phase 3: Gemini Integration
- [ ] Phase 4: Cross-platform MCP
- [ ] Phase 5: Advanced Orchestration
