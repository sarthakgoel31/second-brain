---
title: Building with Claude Code
domains: [#engineering, #ai, #growth]
created: 2026-04-10
updated: 2026-04-10
sources:
  - reference_custom_hooks.md
  - project_progress_tracker.md
  - feedback_do_everything.md
  - feedback_test_before_showing.md
  - feedback_think_hooks.md
---

# Building with Claude Code

Sarthak uses Claude Code not as a coding assistant but as a development operating system — a persistent, memory-equipped, multi-agent environment that orchestrates projects, enforces rules mechanically, and compounds knowledge across sessions. The workspace is architected so that Claude Code can navigate, build, test, and ship across 10+ simultaneous projects with minimal context-switching friction.

## Key Insights
- The workspace is a deliberate information architecture: `work/`, `personal/`, `output/`, `.claude/` each have clear boundaries
- Satellite project pattern separates Claude config (agents, inputs) from source code — keeps repos clean
- Memory is soft (forgotten after compact), hooks are mechanical (always enforced) — prefer hooks for critical rules
- Council pattern (specialist → security → QA → manager) ensures no output reaches the user unchecked
- "Do everything" philosophy: Claude should run setup, install deps, start servers — never leave manual steps for the user
- Always test (tsc, build, curl) before asking the user to refresh — broken demos destroy trust

## Details

### Workspace Architecture
The workspace at `/Users/sarthak/Claude/` is organized into four top-level directories:
- **`work/`**: FloBiz production projects — flo-analytics-llm, myVoiceBooksAI, myBillBook, data-crons
- **`personal/`**: Side projects — trading-monitor, content-listener, claude-paglu, insta-tracker, and more
- **`output/`**: All generated artifacts — HTML pages, Excalidraw diagrams, documents, carousels
- **`.claude/`**: The operating system itself — agents, skills, scripts, and per-project satellite configs

### The Satellite Project Pattern
Source code lives in `work/` or `personal/`. Claude-specific configuration (agents, inputs, project-specific CLAUDE.md) lives in `.claude/projects/`. This separation means:
- Git repos stay clean — no `.claude/` directories polluting PRs
- Agent definitions are centralized and discoverable
- Input files (reference docs, specs) have a predictable drop location
- Multiple Claude sessions can work on different projects without config collision

### Skills (Slash Commands)
11+ custom skills act as instant-access workflows:
- **`/progress`**: Collects daily activity from Claude session JSONL logs and git history across all repos
- **`/zen`**: Auto-triggered meditation with real videos and ElevenLabs voice
- **`/artifact`**: Publish a page to Netlify in one command
- **`/excalidraw`**: Generate architecture diagrams (2 tool calls max — write spec + run generator)
- **`/brain`**: Second brain knowledge base — ingest, compile, query, lint, discover connections
- **`/night-duty`**: Keep Mac awake, dim screen to zero

### Agent Architecture
**Shared agents** (workspace-wide):
- `security-agent`: SQL injection, API safety, data privacy
- `qa-agent`: Output accuracy, edge cases, readability
- `snowflake-agent`: All Snowflake connections and query execution
- `content-listener-agent`: Transcribe + summarize from any URL
- `progress-tracker-agent`: Daily activity collection across all projects

**Per-project agents** follow the council pattern — specialist agents do the work, then security and QA review before the manager approves output for the user.

### The Hook System
7 custom hooks enforce rules that memory alone can't guarantee:
1. **Schema guard**: Prevents direct edits to schema.md / schema-rag.json — must use schema-editor-agent
2. **MBB caution**: Extra confirmation before touching myBillBook codebase
3. **Sierra drift**: Ensures Python backtests stay in sync with Sierra ACSIL studies
4. **Auto-test**: Runs tests automatically after code changes
5. **Free-only**: Blocks introduction of paid APIs in personal projects
6. **Secret leak**: Prevents committing API keys, tokens, credentials
7. **No-auto-LLM**: Prevents auto-firing LLM queries on page load

The critical insight: when you compact a conversation, memory files get summarized and nuance is lost. But hooks run mechanically every time, regardless of context window state. For any rule that absolutely must not be violated, encode it as a hook, not just a memory.

### Memory System
Four memory types persist across conversations:
- **User**: Who Sarthak is, what he builds, his preferences
- **Feedback**: Learned lessons from past mistakes (format: "X happened, so now always do Y")
- **Project**: Current state of each project (status, architecture, next steps)
- **Reference**: API keys, server configs, connection details

### The "Do Everything" Philosophy
Claude Code should be autonomous. When asked to set up a project:
- Clone the repo
- Install dependencies
- Create environment files
- Start the dev server
- Verify it works with a curl or build command
- THEN tell the user it's ready

Never say "now run `npm install` and then `npm start`" — just do it. The user's time is the scarcest resource.

### Test Before Showing
A corollary to "do everything": always verify before presenting. Run `tsc` to check types. Run `npm run build` to catch errors. `curl` the endpoint to confirm it responds. A broken demo wastes more time than the 10 seconds it takes to verify.

## Connections
- [[zero-cost-architecture]] — Claude Code is the force multiplier that makes zero-cost viable — one person + AI operating system = team-scale output
- [[direct-sql-vs-llm-pipeline]] — The no-auto-LLM hook mechanically enforces the direct SQL lesson
- [[knowledge-compounding]] — The memory system and second brain are how knowledge compounds across sessions instead of resetting

## Open Questions
- How should agent responsibilities evolve as projects mature — more specialized or more consolidated?
- What's the right cadence for pruning stale memory files that no longer reflect current project state?
- Could the satellite pattern be formalized into a Claude Code plugin that other developers use?
- At what point does the hook system become over-constraining and need a "break glass" escape?
- How do you onboard a second person into this operating system without them drowning in complexity?
