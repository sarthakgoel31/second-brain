---
title: Lessons from Failures
domains: [#growth, #engineering]
created: 2026-04-10
updated: 2026-04-10
sources:
  - Synthesized from wiki articles: Flo Analytics Pipeline, 6E Trading System, Sierra Chart Hard-Won Learnings, Direct SQL vs LLM Pipeline, myVoiceBooksAI Product, Building with Claude Code, Zero-Cost Architecture, Automation as Lifestyle, How Sarthak Decides, Schema Design as Leverage
---

# Lessons from Failures

A catalogue of every time something burned Sarthak — and the system change it produced. This is the most important article in the wiki because it reveals the meta-pattern that connects all of Sarthak's work: every failure becomes a hook, a schema rule, or an agent. Mistakes are not repeated because they are mechanically prevented from repeating. Memory fades after context compact; hooks run every time. The lesson is never "be more careful" — the lesson is always "build a system that makes this failure impossible."

## Key Insights

- Every failure listed here produced a permanent system change — not a mental note, but a hook, schema rule, agent, or architectural decision
- The meta-pattern: failure --> encoded rule --> mechanical enforcement --> the mistake becomes structurally impossible
- Memory-based rules ("remember to check X") fail because context compacts lose nuance. Hook-based rules ("the system blocks X") succeed because they execute regardless of context
- The failures span every domain — product, trading, engineering, content — but the response pattern is identical in all domains
- The most expensive failures were not bugs; they were architectural mistakes (auto-LLM on page load, weak schema rules) that required rethinking the approach, not fixing the code

## Details

### Failure 1: Schema Rules Too Weak (Flo Analytics)

**What happened:** The flo-analytics-llm schema.md had rules like "use the correct date column." The LLM ignored them. SQL queries used `voucher_date` when `created_at` was correct. `itemable_type` values were hallucinated. The `COMPANIES` join was omitted, leaking data across tenants.

**What it cost:** Weeks of live query failures. Users got wrong answers. The 21-item audit was the cleanup effort.

**The system change:** Schema rules now require three elements: (1) `CRITICAL:` prefix for must-follow rules, (2) `CORRECT:` and `WRONG:` side-by-side examples so the LLM can pattern-match, (3) consequence statements explaining what breaks if the rule is violated ("If you omit this join, you will return data from ALL companies"). This format was not invented theoretically — it was extracted from what actually worked when everything else failed.

**The encoding:** Schema-editor-agent enforces the format. A hook blocks direct edits to schema.md and schema-rag.json — you must go through the agent, which validates consistency.

### Failure 2: Wrong Pip Value ($6.25 instead of $12.50)

**What happened:** The 6E backtest calculated P&L using $6.25/pip — the E7 mini contract value. The actual 6E full-size contract is $12.50/pip. Every P&L figure in the backtest was exactly half of what it should have been.

**What it cost:** Understated the strategy's profitability by 2x. More dangerously, risk calculations were also halved — a position that looked like it risked $500 actually risked $1,000.

**The system change:** The correct pip value ($12.50 for 6E full-size) is now hardcoded in memory and in the trading console's mega engine. The feedback memory explicitly states: "6E full-size = $12.50/pip, not $6.25 (that's E7 mini)."

**The lesson:** Always verify unit economics. The same principle applies to product (mis-pricing a tier) and content (overestimating audience size). Get the base units right before building on top of them.

### Failure 3: Auto-Fire LLM on Dashboard Load (MVB)

**What happened:** The initial myVoiceBooksAI dashboard fired 8 LLM queries simultaneously on page load — one per dashboard metric. Each went through the full pipeline (RAG + SQL generation + Snowflake + summarization). Time per query: 30-77 seconds. The page hung. Chat was blocked. The user's reaction: "what is this bro?"

**What it cost:** A broken demo that eroded trust with stakeholders. The entire dashboard architecture had to be rethought.

**The system change:** Dashboard metrics now use direct SQL (300ms) instead of the LLM pipeline (20-25s). A custom hook (`no-auto-LLM`) mechanically prevents any code from auto-firing LLM queries on page load. The architectural split is permanent: direct SQL for known metrics, LLM pipeline for free-form chat questions.

**The encoding:** The hook checks for LLM calls triggered without explicit user action and blocks them. This rule cannot be forgotten because it is enforced at the tool level, not the memory level.

### Failure 4: IST Double-Offset Bug (Social Tracker)

**What happened:** The social branding tracker manually converted UTC timestamps to IST by adding 5:30 hours. But the browser's `Date` object already auto-converts UTC to the local timezone. The manual offset was applied on top of the browser's offset, showing timestamps 5:30 hours ahead of reality.

**What it cost:** View count timestamps were wrong. Monthly cohort analysis was misaligned. Debugging took longer than building the feature.

**The system change:** Never manually offset timestamps for display. Let the browser handle UTC-to-local conversion. Only manually offset when storing or transmitting (and even then, prefer ISO 8601 with timezone).

### Failure 5: IG Cookies Expiring (Social Tracker)

**What happened:** Instagram aggressively expires session cookies. The social branding tracker's scraping broke every few days, requiring manual re-authentication. Each break meant missing data points in the 176-reel tracking dataset.

**What it cost:** Gaps in tracking data. Manual intervention every 3-5 days.

**The system change:** Built self-healing auto-login with CSRF token reuse. When Instagram returns a 401, the system automatically detects the expired session, re-authenticates, refreshes the cookies, and retries the request. No manual intervention needed.

**The pattern:** This is the self-healing pattern that appears across every automation — the system must handle its own failures, not page the human.

### Failure 6: Windows Firewall Blocking Sierra Data

**What happened:** The trading data fetch agent pulls .scid tick data from a Windows PC over HTTP. Windows Firewall blocked the connection every morning. The firewall had to be manually disabled, the data fetched, and the firewall re-enabled. This broke the morning routine every single day.

**What it cost:** 5-10 minutes of friction every morning, plus the cognitive overhead of remembering to do it.

**The system change:** Built 1-click Start/Stop shortcuts on the Windows Desktop that disable the firewall, wait for the fetch to complete, and re-enable it. The morning data fetch is now a single click instead of a multi-step manual process.

### Failure 7: 8 Hours Debugging Sierra ACSIL Studies

**What happened:** Building the DH_Scanner study from v1 to v11 required 8+ hours of painful debugging across 12 distinct categories of bugs — UTC date handling, bar-close vs tick-level trailing stops, entry bar skip logic, drawing cleanup, alert deduplication, persistent variable initialization, and more.

**What it cost:** 8+ hours of debugging time. Some bugs (like float comparison precision) caused intermittent failures that were nearly impossible to diagnose.

**The system change:** All 12 learnings are encoded directly into the sierra-study-builder-agent as hard constraints. When the agent generates a new ACSIL C++ study, it automatically applies all 12 lessons. The trade-validator-agent then verifies the output against Python backtests trade-by-trade. No future study can be generated without these guardrails.

### Failure 8: Showing Broken UI to User

**What happened:** The MVB dashboard was demoed before testing. Scroll was broken. Timing was off. The user saw a broken product.

**What it cost:** Trust. A broken demo takes more effort to recover from than a delayed demo.

**The system change:** "Test before showing" is now a hard rule encoded in feedback memory. Run `tsc`, `vite build`, `curl` endpoints, open in browser and click through — BEFORE telling anyone it is ready. A hook enforces auto-testing after code changes.

### Failure 9: Schema Edited Directly

**What happened:** Schema.md was edited by hand without going through the schema-editor-agent. The edit broke consistency between schema.md and schema-rag.json. The LLM started generating SQL with stale column references.

**What it cost:** Debugging time to find the inconsistency, plus wrong query results until it was fixed.

**The system change:** A hook blocks ALL direct edits to schema.md and schema-rag.json. The only path is through the schema-editor-agent, which validates consistency between both files and enforces the CRITICAL/CORRECT/WRONG format.

### Failure 10: Paid API Accidentally Used

**What happened:** A personal project inadvertently used a paid API (details vary), violating the zero-cost constraint.

**What it cost:** The violation itself was small, but it represented a breach of the foundational constraint. If one paid API is allowed, the discipline unravels.

**The system change:** A hook checks for paid API keys in personal project code. If detected, it warns before allowing the change. The constraint is mechanical, not aspirational.

### The Meta-Pattern

Every single failure above followed the same response pattern:

```
Failure happens
    --> Root cause identified
    --> Rule written (memory / feedback)
    --> Rule encoded mechanically (hook / agent / schema rule)
    --> Failure becomes structurally impossible
```

This is not "learning from mistakes." This is **engineering mistakes out of existence.** The distinction matters because learning requires remembering, and memory fades (especially after context compact). Engineering requires building, and builds persist.

The same meta-pattern operates across domains:
- **Trading:** 12 Sierra debugging lessons --> encoded in agent --> impossible to generate a study with those bugs
- **Product:** Auto-LLM on page load --> hook blocks it --> impossible to accidentally do it again
- **Engineering:** Direct schema edits --> hook blocks them --> impossible to bypass the agent

The system gets smarter with every failure. It is an immune system: each pathogen produces an antibody.

## Connections

- [[how-sarthak-decides]] — Pattern 6 (encode mistakes into systems) is the formalization of this article's core thesis
- [[building-with-claude-code]] — the hook system (7 custom hooks) is WHERE most of these failures are encoded
- [[schema-design-as-leverage]] — Failure 1 and 9 are both about schema quality; the leverage of good schemas is proven by the cost of bad ones
- [[flo-analytics-pipeline]] — Failures 1, 3, and 9 all originate from the flo-analytics pipeline and shaped its current architecture
- [[sierra-chart-hard-won-learnings]] — Failure 7 is the detailed version; 12 debugging lessons encoded into one agent
- [[6e-trading-system]] — Failure 2 (pip value) directly impacted backtest P&L and risk calculations
- [[direct-sql-vs-llm-pipeline]] — Failure 3 is the origin story of the direct SQL vs LLM architectural split
- [[zero-cost-architecture]] — Failure 10 reinforced the zero-cost constraint with a mechanical guardrail
- [[automation-as-lifestyle]] — Failure 5 (IG cookies) and 6 (Windows Firewall) produced self-healing automation patterns
- [[trading-discipline-and-psychology]] — trading failures and product failures follow the same encode-into-system response
- [[myvoicebooksai-product]] — Failures 3 and 8 shaped the MVB dashboard's architecture and demo discipline
- [[knowledge-compounding]] — each encoded failure adds to a growing immune system that makes all future work safer

## Open Questions

- Is there a failure that produced a WRONG system change — a guardrail that is now overly restrictive?
- What failures have NOT been encoded yet and are still relying on soft memory?
- At what point does the hook system become so defensive that it slows down experimentation?
- Are there patterns in WHEN failures happen — early in a project? during demos? at integration points?
- Could the failure-to-system pipeline be made explicit: a `/failure` skill that prompts for root cause and automatically suggests a hook/agent/schema change?
