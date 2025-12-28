# SpecMap Setup Scripts

Scripts to initialize or integrate SpecMap 3.0 into any project.

## Quick Start

### Windows (PowerShell)

```powershell
# New project
.\specmap-setup.ps1 -Mode new -ProjectName "my-app"

# Integrate into existing project
.\specmap-setup.ps1 -Mode integrate -ProjectPath "C:\Projects\existing-app"
```

### Mac/Linux (Bash)

```bash
# Make executable
chmod +x specmap-setup.sh

# New project
./specmap-setup.sh new my-app

# Integrate into existing project
./specmap-setup.sh integrate ~/Projects/existing-app
```

## Commands

### New Project

Creates a new project folder with full SpecMap structure.

**PowerShell:**
```powershell
.\specmap-setup.ps1 -Mode new -ProjectName "my-app" [-ProjectPath "C:\Projects"] [-ProjectType "web-app"]
```

**Bash:**
```bash
./specmap-setup.sh new <project-name> [project-path] [project-type]
```

**Parameters:**
| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| ProjectName | Yes | - | Name of the new project |
| ProjectPath | No | Current dir | Where to create the project |
| ProjectType | No | web-app | Type: web-app, mobile-app, api, library, cli |

### Integrate Existing Project

Adds SpecMap files to an existing project without overwriting your code.

**PowerShell:**
```powershell
.\specmap-setup.ps1 -Mode integrate [-ProjectPath "C:\Projects\my-app"]
```

**Bash:**
```bash
./specmap-setup.sh integrate [project-path]
```

**Parameters:**
| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| ProjectPath | No | Current dir | Path to existing project |

## What Gets Created

### Directory Structure

```
your-project/
├── .claude/
│   ├── CLAUDE.md              # AI project instructions
│   └── commands/
│       ├── specify.md         # /specify command
│       ├── clarify.md         # /clarify command
│       ├── plan.md            # /plan command
│       ├── tasks.md           # /tasks command
│       └── track.md           # /track command
├── 01-specifications/         # Feature specs folder
├── SPECMAP.md                 # Project rules
├── features.json              # Feature registry
├── progress.md                # Session tracking
└── .gitignore                 # Updated with SpecMap entries
```

### Core Files

| File | Purpose |
|------|---------|
| `SPECMAP.md` | Project rules, critical operations, recovery protocol |
| `features.json` | Feature registry with counters |
| `progress.md` | Session save file with cold start briefing |

## Auto-Detection (Integrate Mode)

When integrating into an existing project, the script auto-detects:

- **Project name** from `package.json` or folder name
- **Project type** from dependencies (React Native → mobile-app, Express → api, etc.)
- **Description** from README.md (first paragraph)

## After Setup

1. **Review** `SPECMAP.md` and update project description
2. **Configure** tech stack and commands sections
3. **Run** `/specify [feature-name]` to create your first specification
4. **Update** `progress.md` after every action

## The Mental Model

> **SpecMap treats AI like a crash-prone process with no memory guarantees.**

That's why we use:
- **Save files** (not logs)
- **Cold start briefings** (for context recovery)
- **Integrity checks** (to verify state)

## Version

SpecMap 3.3.2
