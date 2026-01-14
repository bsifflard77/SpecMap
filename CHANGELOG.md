# Changelog

All notable changes to SpecMap will be documented in this file.

## [3.4.0] - 2026-01-14

### Added
- **Ralph Integration**: Autonomous execution loop for PRD-driven development
  - `/prd` slash command for interactive PRD creation
  - `ralph.ps1` PowerShell script for autonomous story execution
  - Drop-in package (`specmap-ralph/`) for easy adoption in any project
- Brain dump mode: describe features naturally, Claude asks only about gaps
- Git push strategy: automatic commits at story completion and session boundaries
- Cold Start Briefing pattern for instant session recovery

### Changed
- PRD format now uses checkbox-based story tracking
- Progress.md redesigned for ~300 token budget per iteration

## [3.3.2] - 2024-12-28

### Added
- Initial public release
- RULEMAP specification framework (7-element PRD replacement)
- Slash commands: `/specify`, `/clarify`, `/plan`, `/tasks`, `/track`
- Setup scripts for Windows (PowerShell) and Mac/Linux (Bash)
- Comprehensive documentation suite
- Example PayPal integration specification

### Core Philosophy
- Save file approach to AI context management
- Cold start briefings for instant recovery
- Progress tracking as the single source of truth

## Roadmap

### Planned for 3.5.0
- Bash version of ralph.ps1 for cross-platform support
- Integration templates for popular frameworks
- Visual progress dashboard
- Team collaboration features
- CLAUDE.md integration for project-specific rules

---

## Version History

| Version | Date | Status |
|---------|------|--------|
| 3.4.0 | 2026-01-14 | Current |
| 3.3.2 | 2024-12-28 | Previous |

---

## Feedback

Your feedback shapes future versions.

Please report:
- Bugs and issues
- Confusing documentation
- Missing features
- Success stories!
