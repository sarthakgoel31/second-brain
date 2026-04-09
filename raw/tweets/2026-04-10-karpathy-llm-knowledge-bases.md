---
added: 2026-04-10
source: https://x.com/karpathy/status/2039805659525644595
author: Andrej Karpathy
type: tweet + follow-up gist
---

# Karpathy: LLM Knowledge Bases

## The Tweet

Karpathy describes shifting from using LLMs primarily for code to using them for **manipulating knowledge** — stored as markdown and images. A large fraction of his token throughput now goes into knowledge management, not code generation.

## The System

### Three-Folder Architecture:
1. **raw/** — Append-only repository for source materials: research papers (PDF→Markdown), GitHub repos, web-clipped articles, datasets, meeting notes. Uses Obsidian Web Clipper to save images locally.
2. **wiki/** — LLM-generated encyclopedia-style articles organized by concept, with backlinks and an index file.
3. **outputs/** — Query responses, synthesized reports, analysis results.

### The Schema File (CLAUDE.md / AGENTS.md):
- Instruction set defining how the LLM operates the knowledge base
- Specifies: ingestion procedures, index formatting, backlink conventions, linting, conflict resolution, query routing
- "Co-evolved" — refined iteratively as the wiki develops
- The human's primary editorial role is writing/refining the schema, NOT writing articles

### Operations:
- **Compilation**: New material → LLM reads index → identifies novel concepts → creates/updates articles → generates backlinks → refreshes index
- **Linting**: Periodic health check for inconsistencies, missing backlinks, gaps
- **Querying**: Context-loading (read index + relevant full articles) instead of RAG retrieval

## Key Insight: Why This Beats RAG

Traditional RAG chunks documents, losing context and introducing retrieval noise. This approach has the LLM write summaries having read full source context. At query time, it loads the compact index + relevant complete articles — no chunking, no retrieval noise.

## Scale

One research topic grew to ~100 articles, 400,000 words — comparable to PhD dissertation length — all generated autonomously without direct human article authorship.

## Follow-up Gist

Published at: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
- Titled "llm-wiki"
- Intentionally abstract — describes the idea, not a specific implementation
- Invites users to instantiate with their own LLM agent

## Community Reaction

Went viral. Spawned: wikigen, AI-Context-OS, OmegaWiki, and many personal implementations. Triggered widespread "second brain with Claude" movement.
