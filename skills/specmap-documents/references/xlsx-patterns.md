# Excel Dashboard Patterns

Templates and patterns for generating SpecMap Excel dashboards.

## Dashboard Structure

```
specmap-dashboard.xlsx
├── Overview (summary with formulas)
├── Tasks (complete breakdown)
├── Questions (Q&A tracking)
├── Decisions (D-XXX log)
├── Timeline (milestones)
└── RULEMAP (scores by section)
```

## Sheet Templates

### Overview Sheet

```python
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment
from openpyxl.utils import get_column_letter

def create_overview_sheet(wb, project_name, feature_id):
    ws = wb.active
    ws.title = "Overview"
    
    # Styles
    header_font = Font(bold=True, size=14)
    label_font = Font(bold=True)
    formula_font = Font(color="000000")  # Black for formulas
    input_font = Font(color="0000FF")    # Blue for inputs
    
    # Header
    ws['A1'] = f"SpecMap Dashboard: {project_name}"
    ws['A1'].font = Font(bold=True, size=16)
    ws['A2'] = f"Feature: {feature_id}"
    ws['A3'] = f"Generated: =TODAY()"
    
    # Summary Metrics (Row 5+)
    ws['A5'] = "Summary Metrics"
    ws['A5'].font = header_font
    
    # Metrics with FORMULAS (not hardcoded!)
    metrics = [
        ("Total Tasks", "=COUNTA(Tasks!A:A)-1"),
        ("Completed", "=COUNTIF(Tasks!D:D,\"Complete\")"),
        ("In Progress", "=COUNTIF(Tasks!D:D,\"In Progress\")"),
        ("Blocked", "=COUNTIF(Tasks!D:D,\"Blocked\")"),
        ("Pending", "=COUNTIF(Tasks!D:D,\"Pending\")"),
        ("Completion %", "=IF(B7>0,B8/B7,0)"),
        ("Open Questions", "=COUNTIF(Questions!C:C,\"Open\")"),
        ("Decisions Made", "=COUNTA(Decisions!A:A)-1"),
    ]
    
    row = 7
    for label, formula in metrics:
        ws[f'A{row}'] = label
        ws[f'A{row}'].font = label_font
        ws[f'B{row}'] = formula
        ws[f'B{row}'].font = formula_font
        row += 1
    
    # Format completion % as percentage
    ws['B12'].number_format = '0.0%'
    
    return ws
```

### Tasks Sheet

```python
def create_tasks_sheet(wb, tasks):
    ws = wb.create_sheet("Tasks")
    
    # Headers
    headers = ["Task ID", "Name", "Implements", "Status", "Effort", "Depends On"]
    for col, header in enumerate(headers, 1):
        cell = ws.cell(row=1, column=col, value=header)
        cell.font = Font(bold=True)
        cell.fill = PatternFill(start_color="DDDDDD", fill_type="solid")
    
    # Status colors
    status_colors = {
        "Complete": "90EE90",    # Light green
        "In Progress": "FFD700", # Gold
        "Blocked": "FF6B6B",     # Light red
        "Pending": "E0E0E0"      # Light gray
    }
    
    # Data rows
    for row, task in enumerate(tasks, 2):
        ws.cell(row=row, column=1, value=task['id'])
        ws.cell(row=row, column=2, value=task['name'])
        ws.cell(row=row, column=3, value=task.get('implements', ''))
        
        status_cell = ws.cell(row=row, column=4, value=task['status'])
        if task['status'] in status_colors:
            status_cell.fill = PatternFill(
                start_color=status_colors[task['status']], 
                fill_type="solid"
            )
        
        ws.cell(row=row, column=5, value=task.get('effort', ''))
        ws.cell(row=row, column=6, value=task.get('depends', ''))
    
    # Auto-width columns
    for col in range(1, len(headers) + 1):
        ws.column_dimensions[get_column_letter(col)].width = 15
    
    return ws
```

### RULEMAP Scores Sheet

```python
def create_rulemap_sheet(wb, scores):
    ws = wb.create_sheet("RULEMAP")
    
    # Header
    ws['A1'] = "RULEMAP Score Analysis"
    ws['A1'].font = Font(bold=True, size=14)
    
    # Score table
    headers = ["Element", "Focus", "Score", "Status"]
    for col, header in enumerate(headers, 1):
        cell = ws.cell(row=3, column=col, value=header)
        cell.font = Font(bold=True)
    
    elements = [
        ("R", "Role & Authority"),
        ("U", "Understanding & Objectives"),
        ("L", "Logic & Structure"),
        ("E", "Elements & Specifications"),
        ("M", "Mood & Experience"),
        ("A", "Audience & Stakeholders"),
        ("P", "Performance & Metrics"),
    ]
    
    row = 4
    for element, focus in elements:
        ws.cell(row=row, column=1, value=element)
        ws.cell(row=row, column=2, value=focus)
        
        # Score (input cell - blue)
        score_cell = ws.cell(row=row, column=3, value=scores.get(element, 0))
        score_cell.font = Font(color="0000FF")  # Blue for inputs
        
        # Status formula (black)
        status_formula = f'=IF(C{row}>=8,"✅ Ready",IF(C{row}>=6,"⚠️ Review","❌ Needs Work"))'
        ws.cell(row=row, column=4, value=status_formula)
        
        row += 1
    
    # Overall score formula
    ws.cell(row=row+1, column=1, value="OVERALL")
    ws.cell(row=row+1, column=1).font = Font(bold=True)
    ws.cell(row=row+1, column=3, value="=AVERAGE(C4:C10)")
    ws.cell(row=row+1, column=3).font = Font(bold=True)
    ws.cell(row=row+1, column=4, value=f'=IF(C{row+1}>=8,"✅ Ready for Planning","❌ Needs Improvement")')
    
    return ws
```

## Color Standards

| Purpose | Color Code | Font Color |
|---------|-----------|------------|
| Editable inputs | - | Blue (0000FF) |
| Formulas | - | Black (000000) |
| Cross-sheet links | - | Green (008000) |
| Attention needed | Yellow (FFFF00) | Black |
| Complete | Green (90EE90) | Black |
| In Progress | Gold (FFD700) | Black |
| Blocked | Red (FF6B6B) | Black |
| Pending | Gray (E0E0E0) | Black |
| Headers | Gray (DDDDDD) | Black |

## Formula Patterns

### Counting by Status
```
=COUNTIF(Tasks!D:D,"Complete")
=COUNTIF(Tasks!D:D,"In Progress")
=COUNTIFS(Tasks!D:D,"Blocked",Tasks!C:C,"001-*")  # Feature-specific
```

### Percentage Calculations
```
=IF(COUNTA(Tasks!A:A)>1,COUNTIF(Tasks!D:D,"Complete")/(COUNTA(Tasks!A:A)-1),0)
```

### Date Calculations
```
=MAX(Timeline!C:C)-TODAY()  # Days remaining
=NETWORKDAYS(TODAY(),MAX(Timeline!C:C))  # Working days
```

### Conditional Formatting
```python
from openpyxl.formatting.rule import FormulaRule

# Highlight overdue items
red_fill = PatternFill(start_color="FF6B6B", fill_type="solid")
ws.conditional_formatting.add(
    'C2:C100',
    FormulaRule(formula=['$C2<TODAY()'], fill=red_fill)
)
```

## Post-Generation

**CRITICAL**: After generating the workbook, recalculate formulas:

```bash
python /mnt/skills/public/xlsx/scripts/recalc.py output.xlsx
```

This ensures all formula values are calculated before sharing.
