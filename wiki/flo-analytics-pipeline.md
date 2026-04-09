---
title: Flo Analytics Pipeline
domains: [#engineering, #ai, #product]
created: 2026-04-10
updated: 2026-04-10
sources:
  - project_flo_pipeline_speed.md
  - project_flo_query_debugging.md
  - project_flo_remaining_12.md
  - feedback_schema_rag_strength.md
  - feedback_schema_editor_agent.md
  - feedback_no_auto_llm_queries.md
---

# Flo Analytics Pipeline

The flo-analytics-llm pipeline transforms natural-language questions into SQL, executes them against Snowflake, and returns human-readable summaries. The full chain is Question → RAG → SQL → Snowflake → Summary, currently taking 20-25 seconds end-to-end, with a clear path to 10 seconds by switching from Grok to Gemini Flash.

## Key Insights
- Two Grok API calls (SQL generation + summarization) dominate latency — everything else is fast
- Schema rules must be AGGRESSIVELY explicit: CRITICAL labels, CORRECT/WRONG examples, consequence statements — or the LLM silently ignores them
- Direct SQL for dashboards, LLM pipeline for chat — never auto-fire LLM queries on page load
- Snowflake cold-start (auto-suspend resume) adds 5-30s of unpredictable latency
- The 21-item audit is complete; iteration now happens from live query failures, not theoretical gaps

## Details

### Pipeline Stages

**1. RAG Retrieval (~0ms)**
Keyword matching against schema-rag.json to find relevant tables and columns. The schema is small enough (<2MB) to stay in-memory — no vector database needed. Retrieval is essentially instant.

**2. Rewrite Step (0-5s)**
If triggered, the rewrite step translates non-English queries to English and strips SQL-native words that confuse RAG matching. This is where [[regional-language-as-core-value]] meets the technical pipeline. For pure English queries or fast-path romanized Hindi hits, this step is skipped entirely.

**3. SQL Generation via Grok (~8-10s)**
The retrieved schema context plus the (possibly rewritten) question are sent to Grok `grok-3-fast-beta`. The LLM generates a Snowflake-compatible SQL query. This is the single most fragile step:
- **Hallucination risk:** Grok occasionally injects random tokens mid-SQL (e.g., `SELECTRandomWord column_name`)
- **Schema drift:** Without aggressively explicit rules, the LLM defaults to wrong patterns:
  - Uses `itemable_type` values that don't exist in the data
  - Picks `voucher_date` when `created_at` is correct (or vice versa)
  - Forgets the required `COMPANIES` join for multi-tenant isolation
- **Mitigation:** Schema rules use CRITICAL labels, CORRECT/WRONG side-by-side examples, and consequence statements ("If you omit this join, you will return data from ALL companies")

**4. Snowflake Execution (3-30s)**
The generated SQL runs against Snowflake. Warm warehouses respond in 3-5 seconds. Cold warehouses (auto-suspended after inactivity) take 5-30 seconds to resume. If the SQL fails with a compilation error, the pipeline automatically retries by sending the error back to Grok for SQL regeneration.

**5. Summarization via Grok (~5-8s)**
The raw query results are sent to Grok for human-readable summarization. This is the second major latency contributor. The summary is streamed back to the user.

### Performance Budget

| Stage | Current | Target (Gemini Flash) |
|---|---|---|
| RAG | ~0ms | ~0ms |
| Rewrite | 0-5s | 0-2s |
| SQL Generation | 8-10s | 1-2s |
| Snowflake | 3-5s (warm) | 3-5s (warm) |
| Summarization | 5-8s | 1-2s |
| **Total** | **20-25s** | **~10s** |

Gemini Flash is ~3x cheaper and ~4x faster than Grok for these tasks. The switch is the single highest-leverage optimization available.

### Debugging Infrastructure
- **`/query-logs` endpoint:** Returns step-level timing and intermediate outputs for any recent query
- **Step-level logging:** Each pipeline stage logs its input, output, and duration
- **Snowflake retry:** Automatic SQL regeneration on compilation errors (up to 1 retry)

### Schema Management
Schema files (`schema.md` and `schema-rag.json`) are the single most important lever for accuracy. They must ALWAYS be edited via the schema-editor-agent — never directly. The agent enforces formatting rules, validates consistency between the two files, and prevents accidental regressions.

Key schema authoring rules:
- Mark critical constraints with `CRITICAL:` prefix
- Include `CORRECT:` and `WRONG:` example pairs for every non-obvious pattern
- Add consequence statements explaining what breaks if the rule is violated
- Use explicit enum values for columns like `itemable_type` and `voucher_type`

### Known Resolved Issues (21-Item Audit)
All 21 items from the comprehensive audit have been resolved, including: itemable_type hallucination, voucher_date vs created_at confusion, missing COMPANIES join, incorrect aggregation patterns, and timezone handling. Ongoing iteration happens from live query failures surfaced via `/query-logs`.

## Connections
- [[myvoicebooksai-product]] — the product this pipeline powers
- [[regional-language-as-core-value]] — the rewrite step handles multilingual translation
- [[schema-design-as-leverage]] — schema quality is the #1 determinant of pipeline accuracy

## Open Questions
- Does Gemini Flash maintain SQL accuracy at 4x speed, or does quality degrade on complex multi-join queries?
- Should the pipeline cache frequent queries (e.g., "today's sales") to skip the LLM entirely?
- Is there a way to pre-warm Snowflake warehouses before the user's first query of the day?
- Can the retry mechanism learn from past failures to avoid re-generating the same broken SQL pattern?
- Would a SQL validation layer (parse + dry-run) before Snowflake execution catch more errors than post-hoc retry?
