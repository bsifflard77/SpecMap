# SpecMap Skills Package

Claude Skills for specification-driven development using RULEMAP framework.

## Skills Included

### 1. specmap-core
Core specification-driven development system.

**Triggers**: specmap, specification, PRD, requirements, task breakdown, tracking

**Capabilities**:
- Initialize SpecMap projects
- Create RULEMAP-structured specifications
- Track progress with comprehensive ID system
- Calculate RULEMAP quality scores

### 2. specmap-documents
Professional deliverable generation.

**Triggers**: export, dashboard, presentation, Word, Excel, PowerPoint, PDF

**Capabilities**:
- Export specifications as Word documents
- Generate Excel project dashboards
- Create PowerPoint presentations
- Compile PDF documentation packages

### 3. specmap-agents
Multi-agent orchestration system.

**Triggers**: agent, orchestrate, handoff, multi-agent, specialist

**Capabilities**:
- PRD Generator Agent configuration
- Task Planner Agent configuration
- Development Guide Agent configuration
- QA Monitor Agent configuration
- Agent handoff protocols

## Installation

### For Claude Code / Claude.ai

Copy the skills folder to your project:

```bash
cp -r specmap-skills/ your-project/.skills/
```

Or add to Claude's skills directory:

```bash
cp -r specmap-skills/* ~/.claude/skills/
```

### For Other Platforms

See the `platforms/` directory for:
- ChatGPT Custom GPT definitions
- Gemini Gem configurations
- N8N workflow templates

## Quick Start

1. **Initialize a project**:
   ```bash
   python specmap-core/scripts/init_project.py my-app --type web-app
   ```

2. **Create a specification**:
   - Claude will use the specmap-core skill
   - Follow RULEMAP framework
   - Target score ≥ 8.0

3. **Generate deliverables**:
   - Ask Claude to "export as Word document"
   - Ask Claude to "create project dashboard"
   - The specmap-documents skill will activate

4. **Orchestrate agents**:
   - Use agent configurations from specmap-agents
   - Follow handoff protocols between phases

## File Structure

```
specmap-skills/
├── specmap-core/
│   ├── SKILL.md
│   ├── scripts/
│   │   ├── init_project.py
│   │   └── calculate_score.py
│   └── references/
│       ├── specify-workflow.md
│       ├── clarify-workflow.md
│       ├── plan-workflow.md
│       └── tasks-workflow.md
│
├── specmap-documents/
│   ├── SKILL.md
│   └── references/
│       └── xlsx-patterns.md
│
└── specmap-agents/
    ├── SKILL.md
    └── references/
        └── agent-configs.md
```

## Integration with Built-in Skills

The specmap-documents skill integrates with Claude's built-in skills:

| Task | Built-in Skill |
|------|----------------|
| Word documents | `/mnt/skills/public/docx/SKILL.md` |
| Excel dashboards | `/mnt/skills/public/xlsx/SKILL.md` |
| PowerPoint presentations | `/mnt/skills/public/pptx/SKILL.md` |
| PDF reports | `/mnt/skills/public/pdf/SKILL.md` |

## Version

- **Version**: 1.0.0
- **Date**: 2025-12-23
- **Compatibility**: Claude Code, Claude.ai

## License

MIT License - see individual skill files for details.
