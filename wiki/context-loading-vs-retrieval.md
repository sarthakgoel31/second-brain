---
title: Context Loading vs Retrieval
domains: [#ai, #engineering]
created: 2026-04-10
updated: 2026-04-10
sources:
  - raw/tweets/2026-04-10-karpathy-llm-knowledge-bases.md
---

# Context Loading vs Retrieval

Two competing approaches to giving LLMs access to large knowledge: **RAG** (chunk, embed, retrieve fragments) vs. **context loading** (pre-compile summaries, load full articles into context window).

## Key Insights

- RAG loses context by chunking — a paragraph ripped from a paper loses the surrounding argument
- Context loading preserves full document meaning because the LLM read the whole source when writing the summary
- The tradeoff is compute: context loading works when the compiled wiki fits in the context window
- For personal knowledge bases (<2MB of markdown), context loading wins decisively
- For enterprise-scale data, RAG is still necessary — but the threshold keeps moving up as context windows grow

## Details

Karpathy's approach: the LLM reads all raw sources fully during compilation and writes compact wiki articles. At query time, the LLM reads the index (lightweight) to find relevant articles, then loads those articles fully into context. No embedding, no vector search, no chunking.

This is essentially **compile-time summarization** vs. **runtime retrieval**. The compilation step is expensive but happens once per source; queries are cheap because the wiki is already structured.

## Connections

- [[llm-knowledge-bases]] — the system that implements context loading over RAG
- [[schema-design-as-leverage]] — the compilation rules determine output quality

## Open Questions

- What's the practical article count limit before context loading degrades?
- Could a hybrid approach work — context loading for core concepts + RAG for rare/edge queries?
