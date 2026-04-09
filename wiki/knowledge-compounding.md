---
title: Knowledge Compounding
domains: [#growth, #ai, #product]
created: 2026-04-10
updated: 2026-04-10
sources:
  - raw/tweets/2026-04-10-karpathy-llm-knowledge-bases.md
---

# Knowledge Compounding

Structured knowledge grows more valuable with each addition — not linearly, but exponentially — because every new piece creates connections with existing pieces. This is the core argument for maintaining a knowledge base over time.

## Key Insights

- Unstructured notes (Notion, Apple Notes) grow linearly — 100 notes is just 100 notes
- A wiki with backlinks grows combinatorially — each new article potentially connects to all existing ones
- The LLM's ability to cross-link aggressively is what makes compounding possible — humans are bad at maintaining links manually
- Karpathy's 100-article wiki is more valuable than 100 separate documents because of the connection density
- This applies beyond personal knowledge: codebases, products, and relationships also compound through structure

## Details

The "second brain" movement is really about **switching from accumulation to compounding**. Most people accumulate information (bookmarks, saved articles, highlights). Few people structure it. The LLM knowledge base approach automates the structuring — the human just feeds raw material.

The `/brain connect` command exists specifically to surface compounding effects: cross-domain patterns that only become visible when knowledge is structured and interlinked.

## Connections

- [[llm-knowledge-bases]] — the system that enables knowledge compounding through automated structuring
- [[schema-design-as-leverage]] — schemas compound too: better rules → better articles → more valuable connections

## Open Questions

- Is there a minimum critical mass of articles before compounding effects become visible?
- How do you measure the "connection density" of a knowledge base?
- Does pruning old/outdated articles help or hurt compounding?
