---
added: 2026-04-10
source: conversation — building call analyzer to replace ConvoZen
---

# Call Analyzer: Replacing ConvoZen with Internal Tools

## Context
FloBiz pays ConvoZen AI ₹60,000/month for call analysis (40K minutes included, ₹1/min extra, unused rolls over 2 months). Sends ~30K minutes/month. ConvoZen provides 43 columns in their export CSV, but only fills 1 of 9 analysis fields — just `tone`. Disposition: 0/20. Notes: 0/20. Commitment: 0/20. Paying ₹60K for essentially one word per call.

## Solution Built
**Architecture:** MP3 → Cashflohero STT (Deepgram Nova-2, free via internal platform) → Grok LLM (grok-3-fast-beta) → 22-field structured analysis

**Key decision:** Used Cashflohero's own STT (Deepgram Nova-2) over local Whisper because:
1. Free — already part of the voice platform
2. Battle-tested for Hindi, Bhojpuri, Hinglish, regional languages
3. Whisper base hallucinated badly on Bhojpuri audio (produced Korean characters, gibberish)
4. Production-proven on thousands of real calls

**STT approach:** Stream PCM16LE audio via WebSocket to `wss://voice.cashflohero.ai/ws/agent` using a silent "stt-transcriber" agent. Agent replies "ok" to every utterance while we capture `asr_final` events.

## Results (20-call benchmark)
- **STT:** 20/20 transcripts, free, avg ~90s per call
- **LLM:** 20/20 analyzed, avg ~12s per call, ~₹0.3/call with Grok
- **Fields:** 22 per call vs ConvoZen's 1
- **Cost:** ₹3,670/month vs ₹60,000/month = **94% savings (₹56,330/month)**

## Fields We Produce (ConvoZen gives 1)
ConvoZen's 9 analysis fields (we fill 8, they fill 1):
- disposition (THEY: 0/20, US: 20/20)
- tone (THEY: 19/20, US: 20/20)
- notes (THEY: 0/20, US: 20/20)
- last_commitment (THEY: 0/20, US: filled when applicable)
- follow_up_at (THEY: 0/20, US: filled)
- item_name, item_desc, business_name, previous_call_context (all empty from ConvoZen)

Our 13 extra fields:
- summary, customer_sentiment, customer_cooperation_level, language_detected
- commitment (amount, date, method, confidence)
- agent_performance (score 1-10, strengths, weaknesses)
- key_moments, action_items, payment_objection_reason, call_quality_issues
- is_owner, invoice_discussed, amount_discussed, is_repeat_caller

## Key Insight
The "build vs buy" calculation was absurdly lopsided here. ConvoZen was delivering almost nothing for ₹60K. Two free tools (Cashflohero STT + Grok at ~₹0.3/call) produce 20x more analysis. This is the "zero-cost architecture" pattern applied to ops tooling — leverage what you already have (Cashflohero platform) + near-free LLM for the intelligence layer.

## Future
- Calls will come from SlashRTC (telephony provider)
- Output will push to LeadSquared (CRM) or Snowflake
- Dashboard at localhost:8450 for now, will productize

## Pattern
This follows the same pattern as every Sarthak project: irritation with a paid tool → "can we build this?" → shipped same day → 10x better at 1/10th cost.
