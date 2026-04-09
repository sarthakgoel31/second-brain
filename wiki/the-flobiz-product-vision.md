---
title: The FloBiz Product Vision
domains: [#product, #business, #ai]
created: 2026-04-10
updated: 2026-04-10
sources:
  - Synthesized from wiki articles: myVoiceBooksAI Product, Regional Language as Core Value, Flo Analytics Pipeline, MBB Pricing Architecture, MBB Sales and Data Insights, Direct SQL vs LLM Pipeline, Schema Design as Leverage, Zero-Cost Architecture, The Goel Family Builder
---

# The FloBiz Product Vision

The bigger picture behind everything Sarthak builds at FloBiz. At its core: an Indian shopkeeper picks up their phone, speaks in Hindi or Telugu or Gujarati, and gets instant insight into their business — how much they sold today, who owes them money, which products are moving. myBillBook is the invoicing app that millions already use. myVoiceBooksAI adds the intelligence layer: voice-first, regional-language-native analytics powered by the flo-analytics-llm SDK. The vision is not "AI for SMBs" in the abstract — it is a specific, concrete product for a specific, underserved user who has never had access to business analytics before.

## Key Insights

- FloBiz serves Indian SMBs — shopkeepers, traders, small manufacturers — who overwhelmingly do not speak English
- myBillBook is the foundation: a mature invoicing app with millions of users and a tiered pricing model (Silver/Diamond/Platinum/Enterprise)
- myVoiceBooksAI is the intelligence layer: voice/text questions answered via SQL against Snowflake, in any Indian language
- Regional language is THE core value proposition — "It is why we are doing what we are doing!" — not a feature checkbox
- flo-analytics-llm is the SDK powering the pipeline: Question --> RAG --> SQL --> Snowflake --> Summary
- The architecture deliberately splits: dashboard (direct SQL, 300ms) for known metrics, AI chat (LLM pipeline, 20-25s) for free-form questions
- Multiple consumers already exist: myVoiceBooksAI (mobile), Mira (internal platform), web dashboard
- The tension between startup speed and enterprise readiness is real and unresolved

## Details

### The User

The target user is not a tech-savvy founder. It is a shopkeeper in Indore who creates invoices on myBillBook, speaks Hindi, and has never opened a spreadsheet. They want to know "aaj kitna bikra" (how much sold today) and "Sharma ji ka baaki kitna hai" (how much does Sharma owe). They do not want dashboards, filters, or SQL. They want to ask and be answered — in their language, by voice.

This user represents the vast majority of India's 63 million MSMEs. They generate data through myBillBook (invoices, payments, items, parties) but have no way to analyze it. myVoiceBooksAI makes that data accessible for the first time.

### The Product Stack

```
User (voice/text in any language)
    |
    v
myVoiceBooksAI (mobile app / web dashboard)
    |
    v
flo-analytics-llm SDK (npm package)
    |-- RAG retrieval (schema-rag.json, in-memory)
    |-- LLM SQL generation (Grok → Gemini Flash)
    |-- Snowflake execution
    |-- LLM summarization
    |
    v
Response (text + optional graph, streamed, in user's language)
```

The SDK is not embedded — it is published as an npm package (`myvoicebooksai-sdk`) and consumed by multiple clients. This matters because the intelligence layer is reusable: Mira (FloBiz's internal analytics platform) is already connected with API key `flo_mira_prod_key`.

### The Dashboard + Chat Architecture

The MVB dashboard implements a key architectural insight: not everything needs AI.

**Left panel (dashboard):** 8 pre-defined metrics via hand-written SQL — sales today, revenue this month, top customers, pending receivables, low stock. Loads in 300ms. No LLM calls. This is what the user sees immediately on open.

**Right panel (chat):** Free-form questions in any language go through the full flo-analytics-llm pipeline. 20-25 seconds today, target 10 seconds with Gemini Flash. This is for "which product gave me the most profit in March?" — questions that cannot be pre-computed.

The two coexist because they solve different problems. The dashboard answers "what happened?" The chat answers "why?" and "what if?"

### Regional Language Architecture

The translation-first approach handles 22 Indian languages with zero per-language code:

1. Voice input via Flo Voice Labs STT (multilingual)
2. Fast-path for common romanized Hindi ("bikri" --> "sales")
3. LLM translation for everything else (the rewrite step)
4. RAG + SQL in English against the English-language schema
5. Summarization can respond in the user's language
6. TTS reads back via Flo Voice Labs (voice: Riya)

Adding a new language requires zero code changes. The LLM handles translation implicitly. This was a deliberate choice over keyword lists — early attempts with exhaustive term mappings failed because romanized spelling varies wildly across dialects.

### The MBB Foundation

myBillBook provides the data and the distribution:

- **Data:** Every invoice, payment, item, and party a user creates flows into Snowflake. This is the data that flo-analytics-llm queries.
- **Distribution:** MBB has millions of users. myVoiceBooksAI does not need its own acquisition — it can be offered as an upgrade within MBB.
- **Pricing:** MBB's MECE v3 tier structure (Silver/Diamond/Platinum/Enterprise) creates natural gating. Analytics could be a Platinum feature or a standalone add-on — the decision is pending.

The sales data tells a nuanced story: 54.5% of renewals are self-serve, and the split is nearly identical for new users (53.4%). This means the product itself drives retention, not the sales team — a strong signal for product-led growth.

### The Tension: Speed vs Enterprise

Sarthak operates at startup speed: Render free tier, UptimeRobot keep-alive, zero paid APIs, ship-in-one-session mentality. This works for prototyping and demos. But the product is meant for FloBiz production — millions of users, Snowflake cold starts, Grok hallucinations, cold start latency on Render free tier.

The unresolved tensions:
- **Hosting:** Render free tier cold-starts in 30+ seconds. Production would need always-on instances ($7/mo minimum).
- **LLM reliability:** Grok occasionally injects random tokens mid-SQL (`SELECTRandomWord column_name`). Gemini Flash may be more stable but is unproven.
- **Latency:** 20-25 seconds per chat query is acceptable for demos. Is it acceptable for a shopkeeper checking sales between customers?
- **Security:** Multi-tenant isolation relies on a `COMPANIES` join that the LLM must never forget. Schema rules enforce this, but the enforcement is probabilistic (LLM compliance), not deterministic (code guard).
- **Adarsh's decision:** The production deployment path (which hosting, which LLM, which team owns it) is pending Adarsh's approval.

### Multiple Consumers

The SDK architecture means the intelligence layer is not locked to one product:

| Consumer | Interface | Status |
|---|---|---|
| myVoiceBooksAI (mobile) | npm SDK, voice/text | Primary product, demoed |
| Mira (internal) | API with key auth | Connected, flo_mira_prod_key |
| Web dashboard | npm SDK, browser | Implemented, side-by-side layout |
| DA team (internal) | SDK / direct | Available for ad-hoc analysis |

This is the leverage: build the SDK once, expose it everywhere. The marginal cost of adding a new consumer is one API key.

## Connections

- [[myvoicebooksai-product]] — the detailed product article: architecture, dashboard metrics, voice design, hosting
- [[regional-language-as-core-value]] — the deepest product thesis: regional language is not a feature, it is the reason this exists
- [[flo-analytics-pipeline]] — the technical engine: RAG, SQL generation, Snowflake, summarization, schema management
- [[direct-sql-vs-llm-pipeline]] — the architectural split that makes the dashboard fast and the chat flexible
- [[schema-design-as-leverage]] — schema quality is the #1 determinant of query accuracy; CRITICAL/CORRECT/WRONG format was hard-won
- [[mbb-pricing-architecture]] — the business model: MECE v3 tiers, feature gating, conversion funnels
- [[mbb-sales-and-data-insights]] — the data: sales touch vs self-serve analysis, LSQ sync, 300+ fields in Snowflake
- [[zero-cost-architecture]] — the current hosting reality: Render free tier, UptimeRobot, zero burn
- [[the-goel-family-builder]] — Sarthak's identity as a builder at FloBiz, the professional context
- [[building-with-claude-code]] — the satellite project pattern separates Claude config from FloBiz source code, keeping repos clean
- [[knowledge-compounding]] — the SDK's schema accumulates learnings from every failed query, compounding accuracy over time

## Open Questions

- When does the product move from Render free tier to production hosting — what is the trigger?
- Should analytics be a gated feature within MBB's tier structure, or a standalone product with its own pricing?
- Can Gemini Flash deliver both the speed (10s) AND the accuracy that Grok provides, or is there a quality tradeoff?
- What is the path to deterministic multi-tenant isolation — can a code-level guard complement the schema-level LLM instruction?
- How does the product handle Snowflake cold starts gracefully — loading state? cached last-known values? pre-warming?
- Is voice-first the right default for ALL Indian SMB users, or do some segments prefer text? What does the data say?
- At what scale does the in-memory RAG (schema < 2MB) need to move to vector search?
