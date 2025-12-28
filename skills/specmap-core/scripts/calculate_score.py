#!/usr/bin/env python3
"""
RULEMAP Score Calculator

Analyzes a specification file and calculates the RULEMAP score.

Usage:
    calculate_score.py <spec-file>

Examples:
    calculate_score.py spec.md
    calculate_score.py 01-specifications/001-auth/spec.md
"""

import sys
import re
from pathlib import Path


def extract_section_scores(content: str) -> dict:
    """Extract existing section scores from markdown."""
    scores = {}
    
    # Pattern: **Section Score**: [X] or Section Score: X
    pattern = r'\*\*Section Score\*\*:\s*\[?(\d+(?:\.\d+)?)\]?'
    
    # Map sections to RULEMAP elements
    section_map = {
        'R - ROLE': 'R',
        'U - UNDERSTANDING': 'U', 
        'L - LOGIC': 'L',
        'E - ELEMENTS': 'E',
        'M - MOOD': 'M',
        'A - AUDIENCE': 'A',
        'P - PERFORMANCE': 'P'
    }
    
    # Find each section and its score
    for section_name, element in section_map.items():
        # Find section header
        section_pattern = rf'##\s*{re.escape(section_name)}.*?(?=##|\Z)'
        section_match = re.search(section_pattern, content, re.DOTALL | re.IGNORECASE)
        
        if section_match:
            section_text = section_match.group(0)
            score_match = re.search(pattern, section_text)
            if score_match:
                scores[element] = float(score_match.group(1))
    
    return scores


def analyze_section_quality(content: str, section_name: str) -> dict:
    """Analyze quality indicators for a section."""
    
    section_pattern = rf'##\s*{re.escape(section_name)}.*?(?=##|\Z)'
    section_match = re.search(section_pattern, content, re.DOTALL | re.IGNORECASE)
    
    if not section_match:
        return {'exists': False, 'score': 0, 'issues': ['Section not found']}
    
    section_text = section_match.group(0)
    
    issues = []
    score = 10.0  # Start with perfect score
    
    # Check for clarification markers
    clarification_count = len(re.findall(r'\[NEEDS CLARIFICATION', section_text, re.IGNORECASE))
    if clarification_count > 0:
        score -= clarification_count * 1.5
        issues.append(f'{clarification_count} clarification(s) needed')
    
    # Check for TODO markers
    todo_count = len(re.findall(r'\[TODO', section_text, re.IGNORECASE))
    if todo_count > 0:
        score -= todo_count * 1.0
        issues.append(f'{todo_count} TODO item(s)')
    
    # Check for TBD markers
    tbd_count = len(re.findall(r'\[TBD\]|\[TBA\]', section_text, re.IGNORECASE))
    if tbd_count > 0:
        score -= tbd_count * 1.0
        issues.append(f'{tbd_count} TBD item(s)')
    
    # Check for empty placeholders
    placeholder_count = len(re.findall(r'\[\s*\]|\[X+\]|\[\.+\]', section_text))
    if placeholder_count > 0:
        score -= placeholder_count * 0.5
        issues.append(f'{placeholder_count} empty placeholder(s)')
    
    # Check for minimal content
    word_count = len(section_text.split())
    if word_count < 50:
        score -= 2.0
        issues.append('Minimal content (< 50 words)')
    elif word_count < 100:
        score -= 1.0
        issues.append('Brief content (< 100 words)')
    
    # Check for tracking IDs (positive indicator)
    tracking_ids = len(re.findall(r'\d{3}-[RTQDIAM]-\d{3}', section_text))
    if tracking_ids > 0:
        score += min(tracking_ids * 0.2, 1.0)  # Bonus up to 1.0
    
    # Clamp score
    score = max(0.0, min(10.0, score))
    
    return {
        'exists': True,
        'score': round(score, 1),
        'issues': issues,
        'word_count': word_count,
        'tracking_ids': tracking_ids
    }


def calculate_rulemap_score(filepath: str) -> dict:
    """Calculate comprehensive RULEMAP score for a specification."""
    
    path = Path(filepath)
    if not path.exists():
        return {'error': f'File not found: {filepath}'}
    
    content = path.read_text()
    
    # RULEMAP sections
    sections = {
        'R': 'R - ROLE',
        'U': 'U - UNDERSTANDING',
        'L': 'L - LOGIC',
        'E': 'E - ELEMENTS',
        'M': 'M - MOOD',
        'A': 'A - AUDIENCE',
        'P': 'P - PERFORMANCE'
    }
    
    results = {}
    total_score = 0
    section_count = 0
    
    # First, check for explicit scores in the document
    explicit_scores = extract_section_scores(content)
    
    for element, section_name in sections.items():
        if element in explicit_scores:
            # Use explicit score from document
            results[element] = {
                'score': explicit_scores[element],
                'source': 'explicit',
                'section': section_name
            }
        else:
            # Calculate score based on content analysis
            analysis = analyze_section_quality(content, section_name)
            results[element] = {
                'score': analysis.get('score', 0),
                'source': 'calculated',
                'section': section_name,
                'issues': analysis.get('issues', []),
                'exists': analysis.get('exists', False)
            }
        
        total_score += results[element]['score']
        section_count += 1
    
    overall_score = round(total_score / section_count, 1) if section_count > 0 else 0
    
    # Determine status
    if overall_score >= 8.0:
        status = 'Ready for Planning'
    elif overall_score >= 6.0:
        status = 'Needs Minor Clarification'
    elif overall_score >= 4.0:
        status = 'Needs Major Revision'
    else:
        status = 'Incomplete'
    
    return {
        'file': str(path),
        'sections': results,
        'overall_score': overall_score,
        'meets_threshold': overall_score >= 8.0,
        'status': status,
        'threshold': 8.0
    }


def print_report(result: dict):
    """Print formatted score report."""
    
    if 'error' in result:
        print(f"❌ Error: {result['error']}")
        return
    
    print(f"\n📊 RULEMAP Score Report")
    print(f"{'=' * 50}")
    print(f"File: {result['file']}")
    print()
    
    print("Section Scores:")
    print("-" * 50)
    
    for element in ['R', 'U', 'L', 'E', 'M', 'A', 'P']:
        section = result['sections'].get(element, {})
        score = section.get('score', 0)
        source = section.get('source', 'unknown')
        
        # Score indicator
        if score >= 8.0:
            indicator = '✅'
        elif score >= 6.0:
            indicator = '⚠️'
        else:
            indicator = '❌'
        
        section_name = section.get('section', element)
        print(f"  {indicator} {section_name}: {score}/10 ({source})")
        
        # Print issues if any
        issues = section.get('issues', [])
        for issue in issues:
            print(f"      └─ {issue}")
    
    print("-" * 50)
    
    # Overall score
    overall = result['overall_score']
    if result['meets_threshold']:
        print(f"✅ OVERALL SCORE: {overall}/10 (meets threshold)")
    else:
        print(f"❌ OVERALL SCORE: {overall}/10 (below {result['threshold']} threshold)")
    
    print(f"   Status: {result['status']}")
    print()


def main():
    if len(sys.argv) < 2:
        print("Usage: calculate_score.py <spec-file>")
        print("\nExamples:")
        print("  calculate_score.py spec.md")
        print("  calculate_score.py 01-specifications/001-auth/spec.md")
        sys.exit(1)
    
    filepath = sys.argv[1]
    result = calculate_rulemap_score(filepath)
    print_report(result)
    
    # Exit with appropriate code
    if 'error' in result:
        sys.exit(1)
    elif result['meets_threshold']:
        sys.exit(0)
    else:
        sys.exit(2)  # Below threshold


if __name__ == "__main__":
    main()
