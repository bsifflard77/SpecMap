# SpecMap Templates

Ready-to-use templates for SpecMap 3.0 projects.

## Available Templates

### specmap-starter

The standard SpecMap template with all core files and slash commands.

**Structure:**
```
specmap-starter/
├── .claude/
│   ├── CLAUDE.md              # AI project instructions
│   └── commands/
│       ├── specify.md         # /specify command
│       ├── clarify.md         # /clarify command
│       ├── plan.md            # /plan command
│       ├── tasks.md           # /tasks command
│       └── track.md           # /track command
├── 01-specifications/         # Feature specs folder
├── SPECMAP.md                 # Project rules (template)
├── features.json              # Feature registry (template)
├── progress.md                # Session tracking (template)
└── .gitignore                 # Git ignore rules
```

## How to Use

### Option 1: Copy the Template

```bash
# Copy to your project
cp -r specmap-starter/ ~/Projects/my-new-project/

# Navigate to project
cd ~/Projects/my-new-project/

# Replace placeholders
# {{PROJECT_NAME}} - Your project name
# {{PROJECT_TYPE}} - web-app, mobile-app, api, library, cli
# {{PROJECT_DESCRIPTION}} - Brief description
# {{DATE}} - Current date (YYYY-MM-DD)
# {{TIMESTAMP}} - Current timestamp (YYYY-MM-DD HH:MM)
```

### Option 2: Use the Setup Script

The setup scripts in `/scripts/` will automatically create these files with your project details filled in.

```bash
# PowerShell
.\scripts\specmap-setup.ps1 -Mode new -ProjectName "my-app"

# Bash
./scripts/specmap-setup.sh new my-app
```

## Template Placeholders

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `{{PROJECT_NAME}}` | Project name | my-awesome-app |
| `{{PROJECT_TYPE}}` | Project type | web-app |
| `{{PROJECT_DESCRIPTION}}` | Brief description | A task management tool |
| `{{DATE}}` | Current date | 2024-01-15 |
| `{{TIMESTAMP}}` | Current timestamp | 2024-01-15 14:30 |

## After Setup

1. Replace all `{{PLACEHOLDER}}` values in the template files
2. Update `SPECMAP.md` with your tech stack and commands
3. Run `/specify [feature-name]` to create your first feature
4. Update `progress.md` after every action

## Version

SpecMap 3.3.2
