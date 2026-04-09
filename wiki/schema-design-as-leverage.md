---
title: Schema Design as Leverage
domains: [#engineering, #product, #ai]
created: 2026-04-10
updated: 2026-04-10
sources:
  - raw/tweets/2026-04-10-karpathy-llm-knowledge-bases.md
---

# Schema Design as Leverage

Investing time in writing precise rules, constraints, and schemas that govern how systems (or LLMs) operate — rather than doing the work manually each time. The schema compounds: every improvement applies to all future operations.

## Key Insights

- In Karpathy's knowledge base, the human writes the schema, the LLM writes the articles — 1 hour of schema refinement = hundreds of better articles
- This pattern appears everywhere: database schemas, API contracts, design systems, CLAUDE.md files, linting rules
- The ROI of schema work is invisible at first but exponential over time
- Bad schemas produce bad outputs at scale — [[llm-knowledge-bases]] showed that RAG schema rules must be aggressively explicit or LLMs ignore them

## Details

The key insight from building flo-analytics-llm's schema.md was identical: vague rules get ignored, explicit rules with CORRECT/WRONG examples get followed. Whether it's a knowledge base schema or a SQL generation schema, the pattern is the same — **specificity compounds**.

## Connections

- [[llm-knowledge-bases]] — the system where schema design is the primary human contribution
- [[knowledge-compounding]] — schemas enable compounding by ensuring consistent quality at scale

## Open Questions

- When does a schema become too rigid and need loosening?
- How do you evolve schemas without breaking existing content?
