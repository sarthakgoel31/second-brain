---
title: LLM Fallback Chains
domains: [#ai, #engineering]
created: 2026-05-01
updated: 2026-05-01
sources:
  - memory/project_site_auditor.md
  - site-auditor/web/src/lib/gemini.ts
---

# LLM Fallback Chains

When building products on free LLM tiers, no single provider is reliable. The solution: a fallback chain that tries multiple providers in order. If one fails (quota, rate limit, balance), the next takes over seamlessly. The user never sees "AI unavailable."

## Key Insights

- Free tier LLMs have unpredictable quota resets — Gemini's daily limit hits at random times
- Groq (Llama 3.3 70B) is the most reliable free option — fast, consistent, generous limits
- DeepSeek requires paid credits despite marketing as "free" — not truly zero-cost
- The same prompt/schema works across all OpenAI-compatible APIs (Groq, DeepSeek) with minimal changes
- Only Gemini supports image input (screenshots) — text fallbacks lose visual context but still produce useful audits
- Show which LLM produced the analysis — transparency builds trust

## Details

### The Pattern

```typescript
try { return await tryGroq(prompt); }       // Fast, free, reliable
catch { }
try { return await tryGemini(prompt); }     // Screenshots, quota-limited
catch { }
return await tryDeepSeek(prompt);           // Last resort
```

### Key Design Decisions

1. **Validate output structure** after every LLM call — don't trust any provider to return valid JSON
2. **Same system prompt** for all providers — reduces drift between LLM outputs
3. **Tag the output** with which LLM was used — users see "Analysis by Groq Llama 3.3"
4. **Groq first** despite Gemini having screenshots — reliability > richness

## Connections

- [[site-auditor-product]] — first implementation of this pattern
- [[zero-cost-architecture]] — fallback chains are how you build reliable products on free tiers
- [[direct-sql-vs-llm-pipeline]] — knowing when to skip LLM entirely (dashboard KPIs)
- [[schema-design-as-leverage]] — structured JSON output schema enforced across all providers

## Open Questions

- Should the chain be configurable per-user (let power users pick their LLM)?
- Can we add Mistral or Cerebras as additional fallbacks?
