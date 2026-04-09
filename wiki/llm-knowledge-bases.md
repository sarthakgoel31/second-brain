---
title: LLM Knowledge Bases
domains: [#ai, #engineering, #growth]
created: 2026-04-10
updated: 2026-04-10
sources:
  - raw/tweets/2026-04-10-karpathy-llm-knowledge-bases.md
---

# LLM Knowledge Bases

Using LLMs not to write code, but to **compile and maintain structured knowledge** from raw source materials. The human curates inputs and refines the schema; the LLM reads everything fully and generates an interconnected wiki.

## Key Insights

- The highest-leverage use of LLM tokens may not be code generation — it's knowledge synthesis
- A personal wiki compiled by an LLM scales to 100+ articles / 400K words without the human writing a single article
- The human's role shifts from author to **editor-in-chief**: you write the rules (schema), not the content
- This is fundamentally different from note-taking — the LLM actively connects, summarizes, and structures

## Details

### Architecture
Three directories: `raw/` (append-only source materials), `wiki/` (LLM-generated articles), `outputs/` (query responses). A schema file (CLAUDE.md) defines all rules for ingestion, compilation, linting, and querying.

### Why This Beats RAG
Traditional RAG chunks documents and retrieves fragments — losing context and introducing noise. The knowledge base approach has the LLM read sources fully, write compact summaries, then load the index + relevant articles at query time. No chunking, no retrieval noise, full context preservation.

### The Schema is the Product
Karpathy describes the schema as "co-evolved" — refined iteratively based on actual wiki development. The schema defines ingestion procedures, backlink conventions, conflict resolution, and query routing. Writing good schema rules is the core human skill.

## Connections

- [[schema-design-as-leverage]] — the pattern of investing in rules/constraints that compound over time appears across engineering and product
- [[context-loading-vs-retrieval]] — the RAG alternative that preserves full document context
- [[knowledge-compounding]] — how structured knowledge grows more valuable with each addition

## Open Questions

- At what scale does the index-loading approach break down and need retrieval?
- Can multiple people contribute to the same knowledge base, or is it inherently personal?
- How do you handle knowledge that becomes outdated — archive vs. delete vs. annotate?
