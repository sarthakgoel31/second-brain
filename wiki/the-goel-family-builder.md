---
title: The Goel Family Builder
domains: [#growth]
created: 2026-04-10
updated: 2026-04-10
sources:
  - user_sarthak.md
  - project_kedarnath_booking.md
  - project_trading_monitor_status.md
  - feedback_do_everything.md
  - feedback_no_paid_apis.md
  - feedback_mbb_caution.md
---

# The Goel Family Builder

Sarthak Goel is a product builder at FloBiz, where he builds myVoiceBooksAI — a voice-first analytics app for Indian SMBs. On the side, he trades 6E futures with hard-earned money, builds a zero-face AI content brand (Claude Paglu), creates developer tools (VidText), and automates everything from helicopter bookings to meditation breaks. He's a family man planning a Kedarnath + Badrinath yatra with 7 Goel family members, and his core philosophy is simple: build it, don't just talk about it. Every personal project runs at zero investment, every system gets automated, and every output gets tested before shipping.

## Key Insights
- **Builder over reporter:** Sarthak builds with AI rather than reporting on AI — this distinction defines both his professional work and his content strategy
- **Zero investment on personal projects:** No paid APIs, no paid hosting, no subscriptions — creativity must work within constraints
- **"Do everything" philosophy:** Automate, run setup, install deps, start servers — never leave manual steps for yourself or others
- **Trades with hard-earned money:** 6E futures trading is real-stakes, not paper trading — which is why discipline and patience matter so much
- **Regional language empathy:** The MBB user base speaks Hindi, Gujarati, Marathi — regional language support is THE core value proposition, not a nice-to-have
- **Tests before showing:** Always run tsc, build, curl — never ask someone to look at something untested
- **Extreme caution with production systems:** MBB codebase changes require confirmation before touching — respect for systems at scale

## Details

### Family

The Goel family:
- **Parents:** Rakesh and Meenu Goel
- **Brother:** Raghav Goel
- **Uncle and Aunt:** Nitin and Nidhi Goel
- **Twin sister:** Smriti

The family is devout — the Kedarnath + Badrinath yatra planned for May 2026 with all 7 members is a significant spiritual and logistical undertaking. Sarthak built an entire helicopter booking automation system to secure seats, running since March 26.

### Professional Work

At FloBiz, Sarthak builds the analytics layer:
- **myVoiceBooksAI:** Voice/text questions from SMB owners, answered via SQL against Snowflake, with streamed responses and graphs
- **flo-analytics-llm:** The SDK powering the pipeline — question, RAG, SQL generation, Snowflake execution, LLM summarization
- **Data infrastructure:** Snowflake warehouse, LeadSquared CRM integration, management dashboards

He thinks in terms of architecture and optimization — "which approach is more optimized and faster" is a recurring lens. He values UX polish ("super cool" animations like the MBB invoice sent celebration) and believes voice-first interaction is the right model for Indian SMB users.

### Trading

6E (Euro futures) trading with the DH|S2 strategy:
- Sierra Chart as the platform, with custom ACSIL C++ studies
- Multi-timeframe analysis with pivot level detection
- Sentiment from Scotia FX Daily, Google News, Reddit, TradingView
- Full backtest completed — Sierra study at v11
- The through-line from work to trading: **patience** — built the analytics SDK with patience, must apply the same to trading

He wears an Apple Watch and could leverage HealthKit for biometric tracking during trading sessions (heart rate as a tilt indicator).

### Content

Claude Paglu — zero-face AI content reels:
- Remotion-based editing pipeline (React, spring animations, word-by-word captions)
- 5 agents orchestrate the daily pipeline
- Target: 100K followers in 30 days
- Content philosophy: show what you build, not what you read

### The Through-Line

Across every domain — product, trading, content, tools, automation — the pattern is the same:
1. Identify a real problem (not a hypothetical one)
2. Build a system to solve it (not a one-off script)
3. Make it self-healing (handle its own failures)
4. Run it at zero cost (creativity over capital)
5. Be patient (the SDK took patience, trading takes patience, 100K followers will take patience)

The connecting thread is **patience married to action** — not passive waiting, but actively building systems and then trusting them to compound.

## Connections
- [[builder-content-strategy]] — The content brand is a direct expression of the builder identity
- [[vidtext-content-pipeline]] — VidText embodies the zero-cost, build-it-yourself philosophy
- [[automation-as-lifestyle]] — Every recurring task gets automated — this is how Sarthak operates
- [[mbb-sales-and-data-insights]] — The professional context: FloBiz data infrastructure and product decisions
- [[6e-trading-system]] — Trading is where patience gets tested with real money
- [[trading-discipline-and-psychology]] — The emotional side of trading — patience, discipline, avoiding tilt
- [[regional-language-as-core-value]] — The empathy for Indian SMB users who don't speak English

## Open Questions
- How does the "patience" lesson from the SDK translate concretely to trading rules (position sizing, time-based exits)?
- Is there a point where the number of automated systems becomes a maintenance burden that outweighs the time saved?
- Could the Apple Watch biometric data create a "tilt detector" that pauses trading when heart rate spikes?
- What's the 5-year vision — does FloBiz product work, trading, and content converge into something, or do they stay parallel tracks?
