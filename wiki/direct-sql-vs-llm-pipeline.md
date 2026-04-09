---
title: Direct SQL vs LLM Pipeline
domains: [#engineering, #ai, #product]
created: 2026-04-10
updated: 2026-04-10
sources:
  - feedback_no_auto_llm_queries.md
  - project_mvb_dashboard_sdk.md
  - project_flo_pipeline_speed.md
---

# Direct SQL vs LLM Pipeline

A hard-learned lesson from building myVoiceBooksAI: AI should enhance, not replace, things that work better without it. Dashboard metrics that are predictable enough to display on a fixed layout are predictable enough to write SQL for directly. The LLM pipeline exists for free-form questions that can't be anticipated — not for rendering a number that updates every hour.

## Key Insights
- Direct SQL: 300ms. LLM pipeline: 20-25 seconds. That's a 70x performance gap for the same data.
- Never auto-fire LLM queries on page load — this was tried, queries took 30-77 seconds, timed out, and blocked the chat interface
- The user's reaction ("what is this bro?") was the clearest possible signal that the approach was wrong
- If a metric is predictable enough to put on a dashboard, it's predictable enough to write SQL for directly
- The two approaches coexist: Dashboard = direct SQL for known metrics, Chat = LLM for free-form questions

## Details

### The Failure That Taught the Rule
The initial myVoiceBooksAI dashboard attempted to use the flo-analytics-llm pipeline for everything — including the dashboard's pre-defined metrics. On page load, 8 LLM queries fired simultaneously. Each query went through the full pipeline: question → RAG retrieval → SQL generation → Snowflake execution → LLM summarization. Total time: 30-77 seconds per query. The page hung. Chat was blocked. The user experience was unusable.

### The Architecture That Works
**Dashboard side (direct SQL)**:
- 8 pre-defined metrics with hand-written, optimized SQL queries
- Parallel execution against Snowflake via a shared connection singleton (`server/snowflake.ts`)
- The singleton prevents duplicate warehouse resume calls — one connection, many queries
- Metrics load in ~300ms, often before the user's eyes finish scanning the layout
- MBB-style dark UI with side-by-side layout: dashboard left, chat right

**Chat side (LLM pipeline)**:
- Free-form questions go through the full flo-analytics-llm pipeline
- RAG retrieves relevant schema chunks, SQL agent generates the query, LLM summarizes
- 20-25 seconds with dual Grok calls (target: 10s with Gemini Flash switch)
- This is acceptable for ad-hoc questions because the user explicitly asked and expects to wait

### The Shared Snowflake Singleton
Both dashboard and chat share the same Snowflake connection via `server/snowflake.ts`. This avoids the costly warehouse resume that happens on first connection. If the dashboard already warmed the warehouse, the chat query benefits. If the chat query ran first, the dashboard metrics load even faster.

### The Broader Principle
AI is a tool, not a religion. The question is never "can AI do this?" — the question is "should AI do this, or does something simpler work better?" For predictable, structured, repeat-access data: SQL. For unpredictable, natural-language, one-off exploration: LLM. The two live side by side in the same product, each doing what it does best.

## Connections
- [[zero-cost-architecture]] — Direct SQL also saves LLM API tokens, aligning with the zero-cost philosophy
- [[building-with-claude-code]] — The "no-auto-LLM" hook enforces this rule mechanically so it can't be forgotten
- [[schema-design-as-leverage]] — The schema that powers the LLM pipeline also informs which metrics are stable enough for direct SQL

## Open Questions
- Where is the crossover point — at what query complexity does LLM generation become worth the latency?
- Could a caching layer for common LLM-generated queries blur the line between the two approaches?
- Should the dashboard surface "suggested questions" based on what it knows the LLM pipeline handles well?
- Is there a hybrid: SQL-first with LLM fallback for queries that fail or return unexpected results?
