# Second Brain

**A Karpathy-style LLM knowledge base -- raw materials in, structured wiki out.**

Second Brain is a personal knowledge management system where an LLM acts as librarian. You drop source materials (articles, conversations, tweets, notes) into `raw/`, and the system compiles them into an interconnected wiki with backlinks, cross-domain connections, and conflict resolution. Think Obsidian, but the writing and linking is done by Claude.

## `/brain` Skill

This repo also includes the `/brain` slash command skill (`SKILL.md`) for Claude Code. The skill provides six commands for interacting with the knowledge base:

```
/brain ingest              # Process new raw materials into wiki articles
/brain compile             # Rebuild the entire wiki from all raw sources
/brain query "topic"       # Ask a question across all knowledge
/brain lint                # Check wiki health (broken links, orphans, stale content)
/brain connect             # Surface cross-domain insights and patterns
/brain status              # Show stats: article count, word count, last update
/brain add "insight"       # Quick-capture a note for later ingestion
```

**Trigger phrases:** "add to my brain", "brain ingest", "brain compile", "brain query", "connect the dots", "knowledge base", "what does my brain say about"

## Architecture

```
raw/          -- Append-only source materials (you curate what goes in)
wiki/         -- LLM-compiled articles (Claude writes and maintains these)
outputs/      -- Query responses and synthesized reports
scripts/      -- Automation (daily brain feed cron)
SKILL.md      -- Claude Code /brain slash command definition
```

### Data Flow

```
Raw Sources --> Ingest --> Wiki Articles --> Query/Connect --> Insights
     |                        |
     |                   Backlinks +
     |                Cross-references
     |
  articles, conversations, tweets, notes, papers, media
```

## Domains

Knowledge is organized across 7 domains. Every article is tagged with one or more:

| Domain | Tag | Scope |
|---|---|---|
| Trading | `#trading` | 6E futures, price action, market structure, risk management, psychology |
| Product | `#product` | Product thinking, user research, prioritization, SMB insights |
| Engineering | `#engineering` | Architecture, system design, performance, developer tools |
| AI/LLM | `#ai` | LLM patterns, prompt engineering, RAG, agents, AI products |
| Business | `#business` | FloBiz context, SaaS metrics, growth, pricing, go-to-market |
| Content | `#content` | Content creation, audience building, storytelling, distribution |
| Growth | `#growth` | Personal development, career, learning frameworks, mental models |

## Operations

| Command | What it does |
|---|---|
| `/brain ingest` | Read new raw materials, create or update wiki articles, add backlinks |
| `/brain compile` | Full recompilation -- scan all sources, fill gaps, rebuild index |
| `/brain query <question>` | Answer questions grounded in wiki content, save response to outputs |
| `/brain lint` | Health check -- find broken backlinks, orphan articles, missing sources |
| `/brain connect` | Surface non-obvious cross-domain patterns and connections |
| `/brain status` | Show index stats, recent updates, domain coverage |

## Wiki Articles

The compiled wiki currently includes 25+ articles across all domains:

- `6e-trading-system.md` -- Full trading system documentation
- `how-sarthak-builds.md` -- Builder methodology and patterns
- `zero-cost-architecture.md` -- Free-tier-only infrastructure philosophy
- `trading-discipline-and-psychology.md` -- Hard-won trading lessons
- `schema-design-as-leverage.md` -- How schema quality drives LLM accuracy
- `building-with-claude-code.md` -- Agent-first development workflow
- And more -- see `wiki/_index.md` for the full catalog

## Article Format

Every wiki article follows a consistent structure:

```markdown
---
title: Article Title
domains: [#trading, #growth]
created: YYYY-MM-DD
updated: YYYY-MM-DD
sources:
  - raw/articles/source-file.md
---

# Article Title

One-paragraph summary.

## Key Insights
## Details
## Connections (backlinks to related articles)
## Open Questions
```

## Rules

1. **Never fabricate knowledge** -- every insight traces to a source in `raw/`
2. **Prefer depth over breadth** -- one deep article beats five shallow ones
3. **Cross-link aggressively** -- the value is in the connections
4. **Preserve dissent** -- when thinking evolves, keep old reasoning with dates
5. **Use Obsidian-compatible markdown** -- `[[backlinks]]`, standard frontmatter
6. **Backlinks use kebab-case filenames** -- `[[how-sarthak-decides]]` not `[[How Sarthak Decides]]`

## Daily Automation

A daily cron script (`scripts/daily-brain-feed.sh`) extracts key insights from the day's Claude Code sessions and saves them as raw notes for ingestion. Runs at 11:30 PM IST.

## Quick Start

```bash
# Add source material
cp your-article.md raw/articles/

# Ingest new materials (via Claude Code)
claude "/brain ingest"

# Query your knowledge base
claude "/brain query What patterns connect trading discipline and product building?"

# Run health check
claude "/brain lint"

# Find cross-domain connections
claude "/brain connect"
```

---

Built with [Claude Code](https://claude.ai/code)
