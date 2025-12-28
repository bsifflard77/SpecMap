---
name: specmap-documents
description: "Generate professional deliverables from SpecMap project data. Creates Word PRDs, Excel dashboards, PowerPoint presentations, and PDF reports from specifications and tracking data. Use when: (1) Exporting PRD as Word document, (2) Creating project dashboard in Excel, (3) Generating stakeholder presentation, (4) Creating PDF reports or documentation packages, (5) Converting markdown specs to professional formats. Triggers on: 'export', 'generate document', 'create report', 'dashboard', 'presentation', 'Word document', 'Excel', 'PowerPoint', 'PDF', 'stakeholder deliverable'."
---

# SpecMap Documents

Generate professional deliverables from SpecMap project data using Claude's built-in document skills.

## Prerequisites

This skill leverages Claude's built-in skills. Before generating documents:
1. Ensure SpecMap project exists (SPECMAP.md, features.json, progress.md)
2. Read the appropriate built-in skill for the output format

## Document Types

### 1. Word PRD Export

**Use case**: Stakeholder review, formal sign-off, external sharing

**Workflow**:
1. Read `/mnt/skills/public/docx/SKILL.md` completely
2. Parse specification markdown
3. Generate Word document with:
   - Cover page with project info
   - Table of contents
   - RULEMAP sections with formatting
   - Requirements tables
   - Acceptance criteria
   - Stakeholder sign-off section

**Key features**:
- Tracked changes for review cycles
- Comments for stakeholder feedback
- Professional formatting
- Version control header/footer

See [references/docx-patterns.md](references/docx-patterns.md) for templates.

### 2. Excel Dashboard

**Use case**: Project tracking, status reporting, metrics visualization

**Workflow**:
1. Read `/mnt/skills/public/xlsx/SKILL.md` completely
2. Parse TRACKING.md and features.json
3. Generate workbook with sheets:
   - **Overview**: Summary metrics with formulas
   - **Tasks**: Complete task breakdown
   - **Questions**: Open/resolved questions
   - **Decisions**: Architecture decisions
   - **Timeline**: Milestone tracking

**Critical rules** (from xlsx skill):
- Use formulas, NOT hardcoded values
- Blue text for editable inputs
- Black text for formulas
- Yellow highlight for attention items
- Include RULEMAP score gauges

See [references/xlsx-patterns.md](references/xlsx-patterns.md) for templates.

### 3. PowerPoint Presentation

**Use case**: Kickoff decks, sprint reviews, stakeholder updates

**Workflow**:
1. Read `/mnt/skills/public/pptx/SKILL.md` completely
2. Parse specification and progress data
3. Generate presentation with slides:
   - Title slide
   - Problem statement (RULEMAP-U)
   - Solution overview (RULEMAP-L)
   - Key requirements (RULEMAP-E)
   - Timeline and milestones (RULEMAP-P)
   - Risks and mitigation
   - Next steps

**Important**: Use html2pptx workflow (960x540px for 16:9).

See [references/pptx-patterns.md](references/pptx-patterns.md) for templates.

### 4. PDF Reports

**Use case**: Final documentation, audit trails, contract deliverables

**Workflow**:
1. Read `/mnt/skills/public/pdf/SKILL.md` completely
2. Collect all relevant markdown files
3. Generate PDF with:
   - Cover page
   - Table of contents
   - Compiled specifications
   - Implementation summary
   - Quality validation results
   - Sign-off pages

**Merge workflow**: Use pypdf for combining documents.

See [references/pdf-patterns.md](references/pdf-patterns.md) for templates.

## Quick Reference

| Output | Skill to Read | Key Tool |
|--------|--------------|----------|
| Word (.docx) | `/mnt/skills/public/docx/SKILL.md` | docx-js |
| Excel (.xlsx) | `/mnt/skills/public/xlsx/SKILL.md` | openpyxl |
| PowerPoint (.pptx) | `/mnt/skills/public/pptx/SKILL.md` | html2pptx |
| PDF (.pdf) | `/mnt/skills/public/pdf/SKILL.md` | reportlab |

## Data Extraction

### From spec.md
```python
# Extract RULEMAP sections
sections = extract_rulemap_sections(spec_content)
# Returns: {'R': {...}, 'U': {...}, ...}

# Extract requirements
requirements = extract_requirements(spec_content)
# Returns: [{'id': '001-R-001', 'text': '...', 'priority': 'MUST'}, ...]

# Extract tracking IDs
ids = extract_tracking_ids(spec_content)
# Returns: {'requirements': [...], 'tasks': [...], 'questions': [...]}
```

### From TRACKING.md
```python
# Extract task status
tasks = parse_tracking_tasks(tracking_content)
# Returns: [{'id': '001-T-042', 'status': 'Complete', 'name': '...'}, ...]

# Calculate metrics
metrics = calculate_progress_metrics(tasks)
# Returns: {'complete': 15, 'in_progress': 3, 'blocked': 1, 'pending': 10}
```

### From features.json
```python
# Load feature registry
with open('features.json') as f:
    features = json.load(f)
    
# Access counters
next_task_id = features['counters']['task'] + 1
```

## Scripts

- `scripts/export_docx.py` - Export specification as Word document
- `scripts/generate_dashboard.py` - Generate Excel dashboard
- `scripts/create_presentation.py` - Create PowerPoint from spec
- `scripts/compile_pdf.py` - Compile PDF documentation package
