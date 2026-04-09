---
title: Regional Language as Core Value
domains: [#product, #ai, #business]
created: 2026-04-10
updated: 2026-04-10
sources:
  - project_regional_language_priority.md
  - feedback_translate_vs_keywords.md
  - user_sarthak.md
---

# Regional Language as Core Value

Regional language support is not a feature of myVoiceBooksAI — it is the entire reason the product exists. Indian SMB owners (shopkeepers, traders, small manufacturers) overwhelmingly do not speak English. If they cannot ask "bikri kitni hui" in Hindi and get a meaningful answer, the product has zero value. As Sarthak puts it: "It is why we are doing what we are doing!"

## Key Insights
- India has 22 official languages and hundreds of dialects — you cannot enumerate your way to coverage with keyword lists
- LLM translation-first (translate user query to English, then run RAG/SQL) beats massive keyword mapping every time
- A small fast-path of common romanized Hindi/Hinglish terms handles the 80% case for ASCII input without hitting the LLM
- Every surface — STT, clarification prompts, error messages, summaries — must be language-aware, not just the query parser
- Voice is the natural input for non-English speakers; text input in regional scripts is painful on mobile keyboards

## Details

### The Problem
Indian SMB owners ask questions the way they think about their business:
- **Hindi:** "bikri kitni hui" (how much was sold), "aaj ka collection"
- **Telugu:** "ammakam entha" (how much revenue)
- **Gujarati:** "vechan ketlu" (how much sales)
- **Marathi:** "aajchi vikri" (today's sales)

These queries arrive in romanized script (Latin characters), native script (Devanagari, Telugu, Gujarati), or as voice input in the spoken language. A traditional keyword-matching system would need exhaustive term lists across all 22 languages — an impossible maintenance burden that breaks on every dialect variation.

### The Solution: Translation-First Architecture
The flo-analytics-llm pipeline uses a translation-first approach:

1. **Voice input** arrives via Flo Voice Labs STT, which handles multilingual transcription
2. **Text normalization** catches common romanized Hindi/Hinglish terms via a small fast-path (e.g., "bikri" → "sales", "kharch" → "expenses") — this avoids an LLM call for the most frequent patterns
3. **LLM translation** handles everything else — the rewrite step translates the query to English before RAG retrieval
4. **RAG + SQL** operates entirely in English against the English-language schema
5. **Summarization** generates the response, which can be delivered in the user's language
6. **TTS** reads the response back via Flo Voice Labs (voice: Riya)

This architecture means adding a new language requires zero code changes — the LLM handles translation implicitly. The only maintenance is the small fast-path of high-frequency romanized terms.

### Why Not Keyword Lists?
Early attempts used extensive keyword-to-column mappings ("bikri" → sales, "paisa" → amount, etc.). This approach failed because:
- Romanized spelling varies wildly ("bikri" vs "bikree" vs "bikkri")
- Dialect differences are unpredictable
- New terms surface constantly from user queries
- Maintaining lists across 22 languages is an engineering sinkhole
- The LLM handles all of this naturally with zero maintenance

### Design Implications
Regional language support is not isolated to one component — it permeates every product decision:
- **Clarification prompts** must ask follow-ups in the user's language
- **Error messages** cannot be English-only
- **Dashboard labels** should adapt (future)
- **Onboarding flow** should detect language preference from first interaction
- **Schema hints** should include multilingual examples for the LLM

## Connections
- [[myvoicebooksai-product]] — the product this thesis drives
- [[flo-analytics-pipeline]] — the technical pipeline where translation happens
- [[schema-design-as-leverage]] — schema must include multilingual context for the LLM to translate correctly

## Open Questions
- Should the fast-path romanized term list be auto-generated from actual user query logs?
- Is there a quality gap between Flo Voice Labs STT and Whisper for low-resource Indian languages (Odia, Assamese)?
- Can the summarization step auto-detect the user's language and respond in kind without explicit language selection?
- What is the long-tail distribution of languages in the MBB user base — is it 80% Hindi or more distributed?
