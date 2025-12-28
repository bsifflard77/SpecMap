# SpecMap Platform Setup Guide

Step-by-step setup instructions for each supported AI platform.

---

## Claude Code / Claude.ai Setup

### Option 1: Project-Level Skills

Add skills to a specific project:

```bash
# Navigate to your project
cd your-project

# Create skills directory
mkdir -p .skills

# Copy SpecMap skills
cp -r path/to/specmap/skills/* .skills/

# Copy Claude project instructions
cp path/to/specmap/platforms/claude/CLAUDE.md ./

# Copy slash commands
cp -r path/to/specmap/platforms/claude/.claude ./
```

Your project structure:
```
your-project/
├── .skills/
│   ├── specmap-core/
│   ├── specmap-documents/
│   └── specmap-agents/
├── .claude/
│   └── commands/
│       ├── specify.md
│       ├── clarify.md
│       ├── plan.md
│       ├── tasks.md
│       └── track.md
├── CLAUDE.md
└── [your project files]
```

### Option 2: User-Level Skills

Make skills available to all projects:

```bash
# Create user skills directory (if needed)
mkdir -p ~/.claude/skills

# Copy SpecMap skills
cp -r path/to/specmap/skills/* ~/.claude/skills/
```

### Verification

Start a Claude Code session and verify:

```
You: Initialize a SpecMap project called "my-app"

Claude: [Should recognize SpecMap and create project structure]
```

### Using Slash Commands

```
/specify user authentication with OAuth support
/clarify 001-F
/plan 001-F
/tasks 001-F
/track
```

---

## ChatGPT Setup

### Creating Custom GPTs

#### PRD Generator GPT

1. Go to https://chat.openai.com
2. Click your profile → "My GPTs" → "Create a GPT"
3. Configure:
   - **Name**: SpecMap PRD Generator
   - **Description**: AI-powered PRD creation using RULEMAP framework
   - **Instructions**: Copy from `platforms/chatgpt/gpts/prd-generator-gpt.md`
   - **Conversation starters**:
     - "Help me create a PRD for a new feature"
     - "Review and score my existing PRD"
     - "What RULEMAP sections need improvement?"
   - **Capabilities**: Enable Web Browsing, Code Interpreter, File Uploads

4. Add Knowledge Files:
   - Upload `rulemap-framework.md`
   - Upload `prd-template.md`
   - Upload example PRDs

5. Click "Create" or "Update"

#### Task Planner GPT

1. Create another GPT
2. Configure:
   - **Name**: SpecMap Task Planner
   - **Description**: Break down PRDs into actionable tasks
   - **Instructions**: Copy from `platforms/chatgpt/gpts/task-planner-gpt.md`
   - **Conversation starters**:
     - "Break down this PRD into tasks"
     - "Help me estimate these requirements"
     - "What's the best implementation order?"
   - **Capabilities**: Enable Code Interpreter, File Uploads

3. Add Knowledge Files:
   - Upload `task-breakdown-methodology.md`
   - Upload `estimation-guidelines.md`

4. Click "Create"

### Using ChatGPT GPTs

1. Start a new chat
2. Select your SpecMap GPT from the dropdown
3. Describe your feature or paste requirements
4. Follow the guided conversation

### Sharing GPTs

To share with your team:
1. Go to GPT settings
2. Under "Sharing", select "Anyone with a link"
3. Copy and distribute the link

---

## Google Gemini Setup

### Creating Gems

#### SpecMap Spec Writer Gem

1. Go to https://gemini.google.com
2. Click "Gems" in the left sidebar
3. Click "New Gem"
4. Configure:
   - **Name**: SpecMap Spec Writer
   - **Description**: Create RULEMAP-structured specifications
   - **Instructions**: Copy from `platforms/gemini/gems/specmap-gems.md` (Gem 1 section)

5. (Optional) Anchor Google Drive files:
   - Click "Add files"
   - Select your RULEMAP template document
   - Select example specifications

6. Click "Create"

#### SpecMap Task Planner Gem

1. Click "New Gem" again
2. Configure:
   - **Name**: SpecMap Task Planner
   - **Instructions**: Copy from `platforms/gemini/gems/specmap-gems.md` (Gem 2 section)

3. Anchor relevant files if desired
4. Click "Create"

#### SpecMap Dashboard Gem

1. Click "New Gem"
2. Configure:
   - **Name**: SpecMap Dashboard
   - **Instructions**: Copy from `platforms/gemini/gems/specmap-gems.md` (Gem 3 section)

3. Anchor a Google Sheets dashboard template if you have one
4. Click "Create"

### Using Gems

1. Select the Gem from your Gems list
2. Start a conversation
3. Provide your specifications or requirements
4. The Gem will follow its specialized instructions

### Google Workspace Integration

Gems can read anchored Google Drive files:
- Google Docs for templates and examples
- Google Sheets for tracking data
- Google Slides for presentation templates

---

## Cross-Platform Workflow

You can use different platforms for different phases:

| Phase | Recommended Platform | Why |
|-------|---------------------|-----|
| Specify | Claude Code or ChatGPT PRD GPT | Deep conversation, file creation |
| Clarify | Any | Question-based, interactive |
| Plan | Claude Code | Codebase analysis available |
| Tasks | Claude Code or ChatGPT Task GPT | Technical breakdown |
| Implement | Claude Code | Direct file access |
| Track | Gemini Dashboard Gem | Google Sheets integration |

### Transferring Work

To move work between platforms:

1. **Export from source platform**:
   - Copy generated markdown files
   - Save to your project folder

2. **Import to target platform**:
   - Upload files as context
   - Reference the feature ID

3. **Maintain consistency**:
   - Keep all files in your SpecMap project folder
   - Use the same tracking IDs across platforms
   - Update `progress.md` regardless of platform used

---

## Verification Checklist

### Claude Setup
- [ ] Skills copied to `.skills/` or `~/.claude/skills/`
- [ ] Slash commands in `.claude/commands/`
- [ ] `CLAUDE.md` in project root
- [ ] Test: `/specify test feature` works

### ChatGPT Setup
- [ ] PRD Generator GPT created
- [ ] Task Planner GPT created
- [ ] Knowledge files uploaded
- [ ] Test: "Create a PRD for login" works

### Gemini Setup
- [ ] Spec Writer Gem created
- [ ] Task Planner Gem created
- [ ] Dashboard Gem created
- [ ] Test: "Write a specification for..." works

---

## Troubleshooting

### Claude: "Skill not found"
- Verify `SKILL.md` exists in skill folder
- Check YAML frontmatter is valid
- Restart Claude Code session

### ChatGPT: GPT not following instructions
- Check instruction length (may need trimming)
- Verify knowledge files uploaded successfully
- Test with simpler prompts first

### Gemini: Gem not using anchored files
- Re-anchor files and save
- Explicitly reference files in your prompt
- Check file permissions in Google Drive

---

## Next Steps

After setup:

1. **Initialize your first project**:
   ```
   Initialize a SpecMap project for [your-app-name]
   ```

2. **Create your first specification**:
   ```
   /specify [your feature concept]
   ```

3. **Review the generated structure**:
   - Check `SPECMAP.md` for project rules
   - Check `features.json` for feature tracking
   - Check `progress.md` for session state

4. **Iterate until quality threshold**:
   - Review RULEMAP scores
   - Clarify any ambiguities
   - Target ≥ 8.0 before planning
