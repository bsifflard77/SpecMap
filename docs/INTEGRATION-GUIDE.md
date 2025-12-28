# SpecMap 3.0 Integration Guide

How to integrate SpecMap into new or existing projects.

## Table of Contents

1. [Quick Start](#quick-start)
2. [New Project Setup](#new-project-setup)
3. [Existing Project Integration](#existing-project-integration)
4. [Manual Setup](#manual-setup)
5. [Post-Setup Configuration](#post-setup-configuration)
6. [Troubleshooting](#troubleshooting)

---

## Quick Start

### Using Setup Scripts (Recommended)

**Windows (PowerShell):**
```powershell
# New project
.\scripts\specmap-setup.ps1 -Mode new -ProjectName "my-app"

# Existing project
.\scripts\specmap-setup.ps1 -Mode integrate -ProjectPath "C:\Projects\my-app"
```

**Mac/Linux (Bash):**
```bash
# New project
./scripts/specmap-setup.sh new my-app

# Existing project
./scripts/specmap-setup.sh integrate ~/Projects/my-app
```

### Using Template (Manual)

```bash
# Copy template to your project
cp -r templates/specmap-starter/* ~/Projects/my-new-project/

# Replace placeholders (see Template Placeholders section)
```

---

## New Project Setup

### Step 1: Create Project Directory

```bash
mkdir my-new-project
cd my-new-project
```

### Step 2: Run Setup Script

```bash
# From SpecMap repo
./scripts/specmap-setup.sh new my-new-project .
```

Or use PowerShell:
```powershell
.\scripts\specmap-setup.ps1 -Mode new -ProjectName "my-new-project" -ProjectPath "."
```

### Step 3: Verify Structure

Your project should now have:
```
my-new-project/
├── .claude/
│   ├── CLAUDE.md
│   └── commands/
│       ├── specify.md
│       ├── clarify.md
│       ├── plan.md
│       ├── tasks.md
│       └── track.md
├── 01-specifications/
├── SPECMAP.md
├── features.json
├── progress.md
└── .gitignore
```

### Step 4: Configure Project

1. Open `SPECMAP.md` and update:
   - Project description
   - Tech stack
   - Commands (dev, test, build, lint)

2. Initialize git:
   ```bash
   git init
   git add .
   git commit -m "chore: Initialize project with SpecMap 3.3.2"
   ```

---

## Existing Project Integration

### Step 1: Navigate to Project

```bash
cd ~/Projects/existing-project
```

### Step 2: Run Integration Script

```bash
# From your project directory
/path/to/SpecMap/scripts/specmap-setup.sh integrate .
```

Or PowerShell:
```powershell
C:\SpecMap\scripts\specmap-setup.ps1 -Mode integrate -ProjectPath "."
```

### Step 3: Auto-Detection

The script automatically detects:
- **Project name** from `package.json` or folder name
- **Project type** from dependencies
- **Description** from README.md

### Step 4: Review and Customize

1. Review generated `SPECMAP.md`:
   - Verify project description is accurate
   - Update tech stack section
   - Configure commands

2. Review `progress.md`:
   - Update "Last Known Good State" with actual project state
   - Add any existing features to Feature Status table

3. Update `features.json`:
   - Add existing features if documenting current work
   - Or leave empty to start fresh

### Step 5: Commit Changes

```bash
git add .
git commit -m "chore: Integrate SpecMap 3.3.2"
```

---

## Manual Setup

If you prefer manual setup or the scripts don't work for your environment:

### Step 1: Create Directory Structure

```bash
mkdir -p .claude/commands
mkdir -p 01-specifications
```

### Step 2: Copy Core Files

From the SpecMap repo, copy these files:
- `templates/specmap-starter/.claude/CLAUDE.md` → `.claude/CLAUDE.md`
- `templates/specmap-starter/.claude/commands/*` → `.claude/commands/`
- `templates/specmap-starter/SPECMAP.md` → `SPECMAP.md`
- `templates/specmap-starter/features.json` → `features.json`
- `templates/specmap-starter/progress.md` → `progress.md`

### Step 3: Replace Placeholders

In all copied files, replace:
| Placeholder | Replace With |
|-------------|--------------|
| `{{PROJECT_NAME}}` | Your project name |
| `{{PROJECT_TYPE}}` | web-app, mobile-app, api, library, cli |
| `{{PROJECT_DESCRIPTION}}` | Brief description |
| `{{DATE}}` | Today's date (YYYY-MM-DD) |
| `{{TIMESTAMP}}` | Current time (YYYY-MM-DD HH:MM) |

### Step 4: Update .gitignore

Add to your existing `.gitignore`:
```
# SpecMap archives
features.archive.json
```

---

## Post-Setup Configuration

### Configure SPECMAP.md

Update these sections:

#### Project Overview
```markdown
## Project Overview

**Type:** web-app
**Created:** 2024-01-15

A task management application that helps teams track work items,
assign tasks, and monitor progress through customizable workflows.
```

#### Tech Stack
```markdown
## Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | Next.js 14 |
| Database | PostgreSQL |
| Libraries | Prisma, TailwindCSS, Auth.js |
```

#### Commands
```markdown
## Commands

```bash
dev:   npm run dev
test:  npm test
build: npm run build
lint:  npm run lint
```
```

### Document Existing Features (Optional)

If integrating into an existing project with features you want to track:

1. Run `/specify [feature-name]` for each major feature
2. Or manually add to `features.json`:

```json
{
  "features": [
    {
      "id": "001",
      "name": "User Authentication",
      "description": "Login, signup, and password reset",
      "priority": "high",
      "status": "complete",
      "tasks": [],
      "acceptance": []
    }
  ]
}
```

---

## Troubleshooting

### Script Permission Errors (Mac/Linux)

```bash
chmod +x scripts/specmap-setup.sh
```

### PowerShell Execution Policy (Windows)

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Files Already Exist

The integration script will warn you if SpecMap files exist:
- Choose "y" to overwrite
- Choose "n" to abort and manually merge

### Project Type Detection Wrong

The script auto-detects project type. To override:

**PowerShell:**
```powershell
.\specmap-setup.ps1 -Mode integrate -ProjectPath "." -ProjectType "api"
```

**Bash:**
```bash
# Not directly supported - update SPECMAP.md manually after setup
```

### Missing Dependencies

The scripts only require:
- **PowerShell**: PowerShell 5.1+ (built into Windows 10+)
- **Bash**: Bash 4.0+ (standard on Mac/Linux)

No additional dependencies needed.

---

## Next Steps

After setup is complete:

1. **Configure** - Update SPECMAP.md with your project details
2. **Specify** - Run `/specify [feature-name]` to document your first feature
3. **Track** - Update progress.md after every action

The mental model:
> **SpecMap treats AI like a crash-prone process with no memory guarantees.**

That's why progress.md must be updated after every action - it's your save file.
