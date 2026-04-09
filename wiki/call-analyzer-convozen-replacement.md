---
title: Call Analyzer — Replacing ConvoZen with Internal Tools
domains: [#business, #ai, #engineering, #product]
created: 2026-04-10
updated: 2026-04-10
sources:
  - raw/notes/2026-04-10-call-analyzer-convozen-replacement.md
---

# Call Analyzer — Replacing ConvoZen with Internal Tools

Built an internal call analysis tool that replaces ConvoZen AI (₹60K/month) with Cashflohero STT + Grok LLM, saving 94% while producing 22 analysis fields per call vs ConvoZen's 1.

## Key Insights

- ConvoZen charged ₹60K/month but only filled 1 of 9 analysis fields (`tone`). Disposition, notes, commitment — all empty. Classic vendor lock-in with no value delivery.
- Cashflohero's Deepgram Nova-2 STT (already free on the platform) beats local Whisper for Hindi/Bhojpuri. Whisper base hallucinated Korean characters on Bhojpuri audio.
- Grok (grok-3-fast-beta) at ~₹0.3/call produces rich structured JSON: disposition, sentiment, commitment with amount/date/method, agent performance scoring, key moments, action items.
- Total cost at 30K min/month: ~₹3,670 vs ₹60,000 — a 94% reduction.

## Details

**Architecture:** `MP3 → Cashflohero STT (WebSocket, free) → Grok LLM (~₹0.3/call) → 22-field JSON → CSV + Dashboard`

The STT trick: created a silent "stt-transcriber" agent on cashflohero that responds "ok" to every utterance. Stream PCM16LE audio via WebSocket, capture `asr_final` events for the transcript. The agent's LLM response is wasted but the STT is free.

**20-call benchmark results:**
- STT: 20/20 success, avg ~90s per call (streaming at 2x speed)
- LLM: 20/20 success, avg ~12s per call
- Fields: 22 per call (8 matching ConvoZen's schema + 13 extras ConvoZen never provides)

**The 94% cost saving comes from:**
1. STT = free (Cashflohero's own infrastructure)
2. LLM = near-free (Grok fast at $0.004/query)
3. No vendor margin on top

## Connections

- [[zero-cost-architecture]] — this is the ops-tooling version of the same "leverage free tools" pattern
- [[flo-analytics-pipeline]] — same Grok API key and cost model, same pattern of LLM-as-analyst
- [[how-projects-are-born]] — classic irritation→build→ship pattern: "we're paying ₹60K for one word per call"
- [[direct-sql-vs-llm-pipeline]] — contrast: here the LLM IS the right tool (unstructured audio → structured data), unlike dashboards where direct SQL wins
- [[schema-design-as-leverage]] — the LLM analysis prompt is effectively a schema that defines what fields to extract, same principle as flo-analytics schema.md
- [[how-sarthak-decides]] — constraint-first thinking: "what do we already have?" → Cashflohero STT is free → only cost is LLM

## Open Questions

- How to integrate with SlashRTC for real-time call ingestion (currently batch MP3 processing)
- Push to LeadSquared or Snowflake — which downstream is more valuable?
- Can we run this as a post-call webhook from Cashflohero itself? (would eliminate the MP3 step entirely)
- Agent performance scoring needs calibration — are the 1-10 scores consistent across calls?
