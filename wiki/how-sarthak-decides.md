---
title: How Sarthak Decides
domains: [#growth, #product, #engineering, #trading]
created: 2026-04-10
updated: 2026-04-10
sources:
  - All memory files — synthesized decision patterns across 47 memories
---

# How Sarthak Decides

A meta-article about Sarthak's decision-making patterns — not what he built, but HOW he decides what to build, how to build it, and when to stop. These patterns repeat across trading, product, engineering, content, and life.

## Key Insights

- Defaults to "what's the fastest free path?" — cost zero is a hard constraint, not a preference
- Thinks architecturally BEFORE coding — "which approach is more optimized and faster?"
- Trusts data over opinions — Snowflake queries, Amplitude events, LSQ call logs, backtest results
- Ships fast, then hardens — build the thing, demo it, fix what breaks in production
- Automates on second occurrence — if you do something twice, write a script/cron/hook
- Patience in building, impatience in results — will spend weeks on a SDK but wants queries under 10s

## Decision Patterns

### Pattern 1: Constraint-First Thinking
Every decision starts with constraints, not possibilities. "We cannot invest money" isn't a limitation — it's a design parameter that shapes every choice downstream.

- Hosting? → Free tier (Render, Railway, Netlify)
- Transcription? → Local Whisper, not paid API
- Summarization? → Extractive local, not Claude API
- Content editing? → Remotion (free), not paid tools
- Market data? → Scotia PDF + RSS feeds, not Bloomberg terminal

The constraint breeds creativity. Self-healing IG cookies exist because paid API access was off the table. The mega engine's precompute() exists because calling an LLM per-metric was too slow and expensive.

**Cross-domain:** Same pattern in trading — "I don't NEED to trade today" is a constraint that prevents forced entries. Same in content — "builder reels, not news" is a constraint that focuses effort.

### Pattern 2: Architectural Thinking Before Implementation
Sarthak asks "which approach?" before "how to implement?" Almost every major decision involved evaluating 2-3 approaches first:

- Translation vs. keyword lists → chose translation (scales to 22 languages)
- Direct SQL vs. LLM pipeline → chose both (dashboard = SQL, chat = LLM)
- RAG vs. context loading → understood the tradeoff (RAG for enterprise, context for personal)
- Grok vs. Gemini Flash → mapped latency/cost tradeoffs before deciding
- MECE tier structure → iterated through v1/v2/v3 before landing on final

**The tell:** He asks "which approach is more optimized and faster" — optimization isn't premature for him, it's the starting point.

### Pattern 3: Data Over Intuition
When making product/business decisions, Sarthak reaches for data first:

- MBB pricing → Snowflake FY2025 invoice data (avg turnover per tier, feature usage %)
- Sales attribution → LSQ call logs (classified 2,056 users as sales touch vs self-serve)
- Feature gating → Amplitude event data (multi-user 4% usage → remove from Diamond)
- Trading strategy → 436-trade backtest over 9 months before going live
- Content strategy → Decoded 2 influencers' hook patterns before writing scripts

**But:** He also trusts gut on UX — "super cool" animations, "Dark Frost" theme, voice-first design. Data for business decisions, taste for user experience.

### Pattern 4: Ship Fast, Harden in Production
The build pattern is: prototype → demo → fix what breaks → harden.

- flo-analytics-llm: shipped with basic schema → live queries exposed bugs → hardened schema with CRITICAL/WRONG examples
- myVoiceBooksAI: built dashboard in one session → demoed to Vaibhav/Adarsh → fixed scroll, timing, cold start issues
- Trading console: built single HTML file → used it daily → added tabs, replay, sentiment
- Social tracker: shipped basic scraping → IG broke → built self-healing cookies
- Content listener: shipped Whisper → YouTube 429s → added subtitle fallback

**The cycle:** Build → Use → Break → Fix → Repeat. Not waterfall, not pure agile — just relentless iteration driven by actual usage.

### Pattern 5: Automate on Second Occurrence
If Sarthak does something twice manually, it becomes automated:

- Asked Claude for trading levels twice → built trading console with auto-scan
- Checked IG reel views twice → built social tracker with daily cron
- Forgot what he worked on → built progress tracker with 11pm cron
- Manual meditation breaks → built zen mode with auto-trigger hook
- Kedarnath portal checking → built monitor with hourly triggers + multi-channel alerts

**The escalation:** manual → script → cron → self-healing system. Each automation gets more robust over time.

### Pattern 6: Encode Mistakes Into Systems
When something burns him, it becomes a hook, a schema rule, or an agent:

- 8 hours debugging Sierra studies → encoded 12 learnings into sierra-study-builder agent
- Schema edits broke things → hook blocks direct schema.md edits
- Paid API accidentally used → hook checks for paid API keys
- Forgot to test before showing → "test before showing" feedback + hook
- LLM ignored weak schema rules → format hardened to CRITICAL + CORRECT/WRONG examples

**The philosophy:** Mistakes are information. The system should make it impossible to make the same mistake twice. Memory is soft (forgotten after compact); hooks are mechanical (run every time).

### Pattern 7: Parallel Life Across Domains
Sarthak doesn't context-switch between domains — he finds parallels:

- "You built a whole analytics SDK with patience. Apply that same energy to trading."
- "You wouldn't ship code without testing it. Don't enter without delta confirmation."
- Schema accuracy in SQL generation = schema accuracy in knowledge base = schema accuracy in trading rules
- The "do everything" philosophy applies to automation, product, AND personal life (Kedarnath booking)
- Zero-cost constraint applies to projects AND trading (hard-earned money, can't afford to gamble)

**This is the deepest pattern:** Every domain teaches lessons that transfer. The second brain exists to make these transfers visible.

## Connections

- [[the-goel-family-builder]] — who Sarthak is, the values behind these patterns
- [[zero-cost-architecture]] — Pattern 1 in action across all projects
- [[schema-design-as-leverage]] — Pattern 6 — encoding mistakes into rules
- [[trading-discipline-and-psychology]] — Patterns 1, 6, 7 applied to trading
- [[direct-sql-vs-llm-pipeline]] — Pattern 2 — architectural choice over default
- [[flo-analytics-pipeline]] — Patterns 3, 4 — data-driven, ship-then-harden
- [[building-with-claude-code]] — Pattern 5, 6 — automation and hooks
- [[automation-as-lifestyle]] — Pattern 5 at the personal level
- [[mbb-pricing-architecture]] — Pattern 3 — data over intuition for business
- [[knowledge-compounding]] — why these patterns matter more when connected

## Open Questions

- Which pattern is strongest? Which is weakest / most often violated?
- Are there decisions where the "free-first" constraint actually hurt the outcome?
- What new patterns are emerging that haven't crystallized yet?
- How do the patterns evolve as Sarthak's career shifts (trader vs builder vs creator)?
- What would Sarthak's decision framework look like if cost were NOT a constraint?
