---
title: Site Auditor — AI UX Audit Tool
domains: [#product, #engineering, #ai]
created: 2026-05-01
updated: 2026-05-01
sources:
  - memory/project_site_auditor.md
---

# Site Auditor — AI UX Audit Tool

Enter any URL, get an AI-powered UX audit in 60 seconds. Real Google Lighthouse scores for desktop and mobile, LLM analyzes from 4 user personas (Grandma, Teen, Business User, Screen Reader) across 8 UX pillars. Live at audit.sarthakgoel.cv.

## Key Insights

- Combining Lighthouse data with LLM persona analysis produces actionable audits, not just scores
- LLM fallback chain is essential: Gemini quota exhausts daily, Groq is reliable backup
- The 4-persona approach catches issues that pure metrics miss (Grandma can't find CTA, Screen Reader has no alt text)
- Shareable links + embeddable badges create viral loops — each audit is a marketing asset
- PageSpeed API is free (25K/day) — the expensive part is LLM, hence the fallback chain

## Details

### LLM Fallback Chain

```
Groq Llama 3.3 (primary, fast, free) → Gemini Flash (screenshots, quota-limited) → DeepSeek (paid, last resort)
```

Each report shows "Analysis by [LLM name]" badge. Groq moved to primary after Gemini free tier quota kept exhausting.

### Architecture

Next.js 16 on Vercel. PageSpeed Insights API → screenshots + Lighthouse scores → LLM analysis → Supabase persistence. Rate limited to 5 audits/hour/IP. Glassmorphism UI with animated score circles.

## Connections

- [[zero-cost-architecture]] — PageSpeed API free tier + Groq free tier = zero cost
- [[llm-fallback-chains]] — the Gemini→Groq→DeepSeek pattern, reusable across projects
- [[how-projects-are-born]] — built in one session to have a public product for portfolio

## Open Questions

- Should we add historical tracking (audit same URL over time)?
- Can we monetize via white-label reports for agencies?
