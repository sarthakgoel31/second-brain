---
name: brain
description: "Second brain knowledge base. Ingest raw materials, compile wiki, query knowledge, lint, or discover cross-domain connections. Usage: /brain <command>. Commands: ingest, compile, query, lint, connect, status, add. Trigger phrases: 'add to my brain', 'what does my brain say about', 'brain ingest', 'brain compile', 'connect the dots', 'knowledge base'."
---

## What This Skill Does

Manages Sarthak's personal second brain — a Karpathy-style LLM knowledge base at `personal/second-brain/`. Raw materials go in, interconnected wiki articles come out.

## Command Detection

Parse the user's message to determine the command:

- **ingest**: "brain ingest", "ingest this", "add to my brain", "process the raw folder"
- **compile**: "brain compile", "recompile", "rebuild the wiki"
- **query**: "brain query ...", "what does my brain say about ...", "search my knowledge"
- **lint**: "brain lint", "check my wiki", "health check"
- **connect**: "brain connect", "connect the dots", "find patterns", "cross-domain insights"
- **status**: "brain status", "how big is my brain", "brain stats"
- **add**: "brain add ...", "save this to brain", "remember this insight" (adds quick note to `raw/notes/`)

If no command is clear, ask the user what they'd like to do.

## Setup

The knowledge base lives at: `personal/second-brain/`

```
personal/second-brain/
├── CLAUDE.md              ← Schema (rules for the LLM)
├── raw/                   ← Source materials (human curates)
│   ├── articles/          ← Web articles, blog posts
│   ├── papers/            ← Research papers, PDFs
│   ├── tweets/            ← Interesting tweets/threads
│   ├── conversations/     ← Key insights from conversations
│   ├── notes/             ← Quick brain dumps
│   └── media/             ← Images, screenshots, diagrams
├── wiki/                  ← Compiled knowledge (LLM writes)
│   ├── _index.md          ← Master index
│   └── _changelog.md      ← What changed and when
└── outputs/               ← Query responses, reports
```

**Always read `personal/second-brain/CLAUDE.md` first** — it contains the full schema with article format, rules, and domain tags.

## Command: INGEST

1. Read the schema at `personal/second-brain/CLAUDE.md`
2. Scan `raw/` for new or unprocessed materials
3. For each source:
   - Read it fully (never chunk)
   - Extract key concepts, insights, decisions, mental models
   - Create or update wiki articles following the article format in the schema
   - Add backlinks to related articles
   - Add source attribution
4. Update `wiki/_index.md`
5. Append to `wiki/_changelog.md`
6. Report: N sources processed, N articles created, N articles updated

If the user provides content inline (not as a file), save it to `raw/notes/YYYY-MM-DD-<slug>.md` first, then ingest.

## Command: COMPILE

1. Read the schema
2. Read `wiki/_index.md` for current state
3. Scan ALL `raw/` materials
4. Identify gaps and stale articles
5. Regenerate/update articles
6. Rebuild index
7. Run lint
8. Report results

## Command: QUERY

1. Read the schema
2. Read `wiki/_index.md`
3. Identify relevant articles based on the question
4. Read those articles fully
5. Synthesize answer grounded in wiki content
6. If insufficient info, suggest what raw material would help
7. Save response to `outputs/query-YYYY-MM-DD-<slug>.md`

## Command: LINT

1. Read the schema
2. Scan all wiki articles checking for:
   - Broken `[[backlinks]]`
   - Orphan articles (nothing links to them)
   - Missing source attributions
   - Missing or incorrect domain tags
   - Stale content
3. Auto-fix safe issues
4. Write report to `outputs/lint-report-YYYY-MM-DD.md`
5. Show summary to user

## Command: CONNECT

This is the magic — finding cross-domain patterns.

1. Read the full index and all article summaries
2. Look for non-obvious connections:
   - A trading lesson that applies to product building
   - An engineering pattern that mirrors a business strategy
   - An AI technique useful for content creation
   - Mental models that span domains
3. Write "Connections Report" to `outputs/connections-YYYY-MM-DD.md`
4. Present the most surprising/valuable connections to the user

## Command: STATUS

1. Count files in `raw/` by subdirectory
2. Count articles in `wiki/`
3. Count articles by domain tag
4. Show total word count
5. Show last ingest/compile date from changelog
6. Present a clean summary

## Command: ADD

Quick capture — save an insight without full ingestion:

1. Take the user's text
2. Save to `raw/notes/YYYY-MM-DD-<slug>.md` with basic frontmatter:
   ```markdown
   ---
   added: YYYY-MM-DD
   source: conversation
   ---
   
   <user's text>
   ```
3. Confirm saved, suggest running `/brain ingest` later to compile it into the wiki

## Important Rules

- Always read the CLAUDE.md schema before any operation
- Never fabricate knowledge — every wiki claim traces to a source
- Write for future-Sarthak who has no memory of original context
- Cross-link aggressively — connections are the value
- Use Obsidian-compatible markdown (`[[backlinks]]`, standard frontmatter)
- Keep the index under 200 entries
