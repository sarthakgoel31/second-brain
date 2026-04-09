---
title: myVoiceBooksAI Product
domains: [#product, #engineering, #ai]
created: 2026-04-10
updated: 2026-04-10
sources:
  - project_mvb_dashboard_sdk.md
  - project_mvb_ui_revamp.md
  - project_hosting_plan.md
  - project_mira_integration.md
  - project_flo_pipeline_speed.md
  - user_sarthak.md
---

# myVoiceBooksAI Product

myVoiceBooksAI is a mobile app built for Indian SMB owners — shopkeepers, traders, small manufacturers — who want to ask questions about their business data in their own language and get instant, visual answers. It combines a fast dashboard with an AI-powered chat panel, all driven by the flo-analytics-llm SDK, with voice as the primary interaction mode.

## Key Insights
- Indian SMBs need voice-first, regional-language-native analytics — not English dashboards
- Side-by-side layout (dashboard + chat) serves two distinct needs: quick glance metrics and exploratory questions
- Direct SQL for the dashboard (300ms) versus LLM pipeline for chat (20-25s) is a deliberate architectural split — speed where it matters, flexibility where it's needed
- Dark Frost theme with glassmorphism signals a premium, modern product in a market flooded with cheap-looking tools
- Free-tier hosting (Render + UptimeRobot) keeps burn at zero while the product finds fit

## Details

### Architecture
The app is a mobile-first frontend backed by a Node/Express server running the flo-analytics-llm SDK (published as the `myvoicebooksai-sdk` npm package). Authentication uses OTP via the myBillBook API. On login, user context (name, items, parties) is fetched from Snowflake to personalize responses.

### Dashboard
The left panel (or top on mobile) shows 8 pre-computed metrics via direct SQL queries hitting Snowflake:
1. **sales_today** — today's invoice count and total
2. **revenue_this_month** — month-to-date revenue
3. **sales_trend** — 7-day or 30-day sales chart
4. **most_sold** — top-selling items by quantity
5. **top_customers** — highest-value customers
6. **top_products** — highest-revenue products
7. **pending_receivables** — outstanding payments
8. **low_stock** — items below reorder threshold

These load in ~300ms with no LLM calls — a deliberate choice after learning that auto-firing LLM queries on page load is a terrible UX.

### AI Chat Panel
The right panel (440px wide on desktop) accepts free-form questions in any language. Questions flow through the [[flo-analytics-pipeline]]: RAG retrieval, SQL generation, Snowflake execution, and summarization. Responses stream back with text and optional graphs. The full pipeline takes 20-25s today, with a path to 10s via Gemini Flash.

### Voice-First Design
Flo Voice Labs (voice: Riya) is always connected. The app auto-sends voice transcripts as queries and reads back every response via TTS. STT, clarification prompts, and summaries all work across languages — this is not a bolt-on feature, it is the core interaction model. See [[regional-language-as-core-value]] for why this matters.

### Visual Design
Dark Frost theme: `#09090b` base black, `#3b82f6` deep blue accent (never bright/pastel on dark backgrounds), glassmorphism panels, Inter font throughout. The UI was revamped to match MBB's premium feel while staying distinct.

### Hosting and Distribution
Both frontend and backend run on Render.com free tier. UptimeRobot pings keep the services alive past Render's 15-minute spin-down. The SDK is importable by other consumers — Mira platform is already integrated as an external consumer with API key `flo_mira_prod_key` set via Render environment variables.

### Team and Demo
Demoed to the team (Vaibhav, Adarsh) on Google Meet. The product is positioned as the voice-native analytics layer for myBillBook's 10M+ SMB user base.

## Connections
- [[flo-analytics-pipeline]] — the technical engine powering the AI chat panel
- [[regional-language-as-core-value]] — the foundational thesis driving product decisions
- [[schema-design-as-leverage]] — schema quality directly determines answer accuracy
- [[mbb-pricing-architecture]] — MBB's plan structure determines which users get access to analytics

## Open Questions
- Can Gemini Flash actually hit 10s end-to-end without sacrificing SQL accuracy?
- What's the right trigger to upsell from dashboard to chat — should pending_receivables or low_stock auto-suggest a deeper question?
- How does the product behave when Snowflake cold-starts (5-30s resume) — should the dashboard cache last-known values?
- Is there a path to offline-first for areas with intermittent connectivity?
