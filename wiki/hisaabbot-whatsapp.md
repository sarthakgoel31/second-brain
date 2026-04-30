---
title: HisaabBot — WhatsApp Expense Splitter
domains: [#product, #engineering]
created: 2026-05-01
updated: 2026-05-01
sources:
  - memory/project_whatsapp_bot.md
---

# HisaabBot — WhatsApp Expense Splitter

Split group expenses and track personal spending — all inside WhatsApp. NLP-powered expense detection from messages, automatic fair splitting across group members, personal finance tracking via chat. No app download needed.

## Key Insights

- WhatsApp is the universal platform in India — meeting users where they already are
- NLP parsers must require expense signal words — bare numbers should never be treated as expenses
- Group splitting + personal tracking in the same bot doubles the use case
- No app download needed is the ultimate distribution advantage

## Connections

- [[how-projects-are-born]] — born from splitting dinner bills manually in WhatsApp groups
- [[regional-language-as-core-value]] — Hindi NLP parsing for Indian expense messages
- [[zero-cost-architecture]] — Node.js + SQLite + whatsapp-web.js, zero cost

## Open Questions

- Hetzner server deployed but QR linking needs re-test
- Can we add UPI payment integration for instant settlements?
