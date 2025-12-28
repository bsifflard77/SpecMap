#!/usr/bin/env python3
"""
SpecMap Project Initializer

Creates the core SpecMap project structure with SPECMAP.md, features.json, and progress.md.

Usage:
    init_project.py <project-name> [--path <output-path>] [--type <project-type>]

Examples:
    init_project.py my-app
    init_project.py e-commerce --path ./projects --type web-app
"""

import sys
import json
from pathlib import Path
from datetime import datetime

SPECMAP_MD_TEMPLATE = '''# SpecMap Project: {project_name}

**Type**: {project_type}
**Created**: {date}
**Version**: 1.0.0

---

## Project Rules

### Quality Standards
- All specifications must achieve RULEMAP score ≥ 8.0
- No `[NEEDS CLARIFICATION]` markers before planning
- All requirements must have testable acceptance criteria
- Update progress.md after EVERY action

### Tracking ID Format
```
[FEATURE]-[TYPE]-[NUMBER]
```

Types:
- F: Feature
- R: Requirement
- T: Task
- Q: Question
- D: Decision
- I: Issue
- A: Acceptance criterion
- M: Milestone

### Workflow
```
specify → clarify → plan → tasks → implement → track
```

### File Structure
```
{project_name}/
├── SPECMAP.md          # This file - project rules
├── features.json       # Feature registry
├── progress.md         # Session heartbeat
└── 01-specifications/
    └── [###-feature-name]/
        ├── spec.md     # RULEMAP specification
        ├── plan.md     # Implementation plan
        ├── tasks.md    # Task breakdown
        └── TRACKING.md # Feature progress
```

---

## RULEMAP Framework

| Element | Focus |
|---------|-------|
| **R** - Role | Authority & responsibility |
| **U** - Understanding | Objectives & success criteria |
| **L** - Logic | Structure & flow |
| **E** - Elements | Specifications & constraints |
| **M** - Mood | Experience & aesthetics |
| **A** - Audience | Stakeholders & users |
| **P** - Performance | Metrics & success criteria |

---

## Quick Commands

### Initialize New Feature
1. Create folder: `01-specifications/[###]-[feature-name]/`
2. Create spec.md using RULEMAP template
3. Register in features.json
4. Update progress.md

### Daily Workflow
1. Check progress.md for current state
2. Continue work on In Progress items
3. Update progress.md after each action
4. Log blockers immediately

---

## Project Status

**Current Phase**: Initialization
**Active Features**: 0
**Next Action**: Create first feature specification
'''

FEATURES_JSON_TEMPLATE = {
    "project": {
        "name": "",
        "type": "",
        "created": "",
        "version": "1.0.0"
    },
    "features": [],
    "counters": {
        "feature": 0,
        "requirement": 0,
        "task": 0,
        "question": 0,
        "decision": 0,
        "issue": 0,
        "acceptance": 0,
        "milestone": 0
    }
}

PROGRESS_MD_TEMPLATE = '''# Progress: {project_name}

**Last Updated**: {date}

---

## Current Session

### Active Work
- ⏳ Project initialized, ready for first feature

### Blockers
- None

### Next Actions
1. Create first feature specification
2. Define core requirements
3. Begin RULEMAP analysis

---

## Session History

### {date}

#### Completed
- ✅ Project initialized
- ✅ Created SPECMAP.md
- ✅ Created features.json
- ✅ Created progress.md

#### Decisions Made
- None yet

#### Questions Raised
- None yet

---

## Quick Stats

| Metric | Count |
|--------|-------|
| Features | 0 |
| Requirements | 0 |
| Tasks | 0 |
| Open Questions | 0 |
| Decisions Made | 0 |

---

## Notes

[Add session notes, observations, and insights here]
'''


def init_project(project_name: str, output_path: str = ".", project_type: str = "web-app"):
    """Initialize a new SpecMap project."""
    
    # Create project directory
    project_dir = Path(output_path).resolve() / project_name
    
    if project_dir.exists():
        print(f"❌ Error: Project directory already exists: {project_dir}")
        return None
    
    try:
        project_dir.mkdir(parents=True, exist_ok=False)
        print(f"✅ Created project directory: {project_dir}")
    except Exception as e:
        print(f"❌ Error creating directory: {e}")
        return None
    
    date = datetime.now().strftime("%Y-%m-%d")
    
    # Create SPECMAP.md
    specmap_content = SPECMAP_MD_TEMPLATE.format(
        project_name=project_name,
        project_type=project_type,
        date=date
    )
    (project_dir / "SPECMAP.md").write_text(specmap_content)
    print("✅ Created SPECMAP.md")
    
    # Create features.json
    features_data = FEATURES_JSON_TEMPLATE.copy()
    features_data["project"]["name"] = project_name
    features_data["project"]["type"] = project_type
    features_data["project"]["created"] = date
    (project_dir / "features.json").write_text(json.dumps(features_data, indent=2))
    print("✅ Created features.json")
    
    # Create progress.md
    progress_content = PROGRESS_MD_TEMPLATE.format(
        project_name=project_name,
        date=date
    )
    (project_dir / "progress.md").write_text(progress_content)
    print("✅ Created progress.md")
    
    # Create specifications directory
    specs_dir = project_dir / "01-specifications"
    specs_dir.mkdir(exist_ok=True)
    print("✅ Created 01-specifications/")
    
    print(f"\n✅ SpecMap project '{project_name}' initialized successfully!")
    print(f"   Location: {project_dir}")
    print("\nNext steps:")
    print("1. Create your first feature specification in 01-specifications/")
    print("2. Use the RULEMAP framework for comprehensive requirements")
    print("3. Update progress.md after every action")
    
    return project_dir


def main():
    if len(sys.argv) < 2:
        print("Usage: init_project.py <project-name> [--path <path>] [--type <type>]")
        print("\nExamples:")
        print("  init_project.py my-app")
        print("  init_project.py e-commerce --path ./projects --type web-app")
        print("\nProject types: web-app, mobile-app, api, library, cli")
        sys.exit(1)
    
    project_name = sys.argv[1]
    output_path = "."
    project_type = "web-app"
    
    # Parse optional arguments
    args = sys.argv[2:]
    i = 0
    while i < len(args):
        if args[i] == "--path" and i + 1 < len(args):
            output_path = args[i + 1]
            i += 2
        elif args[i] == "--type" and i + 1 < len(args):
            project_type = args[i + 1]
            i += 2
        else:
            i += 1
    
    print(f"🚀 Initializing SpecMap project: {project_name}")
    print(f"   Type: {project_type}")
    print(f"   Location: {output_path}")
    print()
    
    result = init_project(project_name, output_path, project_type)
    
    sys.exit(0 if result else 1)


if __name__ == "__main__":
    main()
