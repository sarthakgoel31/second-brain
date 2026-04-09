---
title: MBB Pricing Architecture
domains: [#business, #product]
created: 2026-04-10
updated: 2026-04-10
sources:
  - project_mbb_pricing_revamp.md
  - reference_amplitude_api.md
---

# MBB Pricing Architecture

myBillBook is shifting from annual to monthly subscription plans, requiring a complete rethink of feature gating. The MECE v3 plan structure organizes features into four tiers based on business maturity — from basic invoicing to full compliance — with pricing backed by actual Snowflake usage data and Amplitude feature adoption metrics.

## Key Insights
- Four tiers map to business maturity stages, not arbitrary feature bundles: Silver ("I bill") → Diamond ("I collect") → Platinum ("I run operations") → Enterprise ("Full compliance")
- Multi-user was removed from Diamond because only 4% of Diamond users actually used it — data-driven pruning, not guesswork
- Monthly plans expose multi-business gaming: the annual-to-monthly ratio drops from 3.6x to 1.0x, confirming users create multiple accounts to avoid upgrading
- Platinum and Diamond have nearly identical average business sizes (~1Cr vs ~1.15Cr), suggesting the tier boundary needs sharper differentiation
- Conversion funnels are designed as natural progressions: seeing overdue invoices (Silver) leads to wanting manual reminders (Diamond) leads to wanting auto-reminders (Platinum)

## Details

### MECE v3 Plan Structure

**Silver — "I bill"**
The entry tier for businesses that just need to create and send invoices. Core features: invoice creation, basic item/party management, simple reports. This is the free or low-cost tier that captures the widest funnel.

**Diamond — "I collect"**
For businesses that need to track and collect payments. Adds: payment reminders (manual), overdue tracking, payment links, basic POS. Multi-user was deliberately removed from this tier — only 4% of Diamond users enabled it, making it dead weight that inflated the price without driving upgrades.

**Platinum — "I run operations"**
For businesses managing day-to-day operations beyond billing. Adds: auto-reminders, unlimited recurring billing, advanced POS, multi-user access, tiered reports. This is where the conversion funnel from Diamond naturally leads — once you see overdue invoices and send manual reminders, you want automation.

**Enterprise — "Full compliance"**
For businesses needing GST filing, e-invoicing, e-way bills, audit trails, and multi-branch management. Average business size: Rs 3.81 Cr — significantly larger than other tiers.

### Feature Gating Decisions

| Feature | Old Tier | New Tier | Rationale |
|---|---|---|---|
| Multi-user | Diamond | Platinum | 4% Diamond usage — not worth the price inflation |
| POS (basic) | Diamond | Diamond | High adoption, natural fit for collection |
| POS (advanced) | Diamond | Platinum | Low adoption at Diamond level |
| Reports (basic) | All | Silver+ | Universal need |
| Reports (advanced) | Diamond | Platinum | Power-user feature |
| Auto-reminders | Diamond | Platinum | Key upgrade trigger from Diamond |
| Auto-billing (5 recurring) | - | Diamond | Intro hook for recurring billing |
| Auto-billing (unlimited) | - | Platinum | Full unlock after proving value |

### Conversion Funnels

**Overdue → Reminders Funnel:**
Silver user sees overdue invoices → realizes they need to chase payments → upgrades to Diamond for manual reminders → gets tired of manual work → upgrades to Platinum for auto-reminders.

**Auto-Billing Funnel:**
Silver user creates one-off invoices → Diamond introduces 5 recurring billing slots → user hits the limit → upgrades to Platinum for unlimited recurring.

### Business Size Data (from Snowflake)

| Tier | Avg Annual Revenue | Implication |
|---|---|---|
| Silver | Rs 40.7 Lakh | Micro-businesses, price-sensitive |
| Diamond | Rs 1.15 Crore | Small businesses, willing to pay for collection tools |
| Platinum | Rs 1.01 Crore | Nearly identical to Diamond — tier boundary is blurry |
| Enterprise | Rs 3.81 Crore | Clear separation, compliance-driven |

The Platinum-Diamond overlap (Rs 1.01Cr vs Rs 1.15Cr) is a red flag. These tiers need sharper feature differentiation to justify the price gap, or they risk cannibalizing each other.

### Multi-Business Gaming
Analysis confirmed that users create multiple free/Silver accounts to avoid upgrading. The ratio of businesses-per-user drops from 3.6x on annual plans to 1.0x on monthly plans. Monthly pricing naturally discourages this behavior because the cost of maintaining multiple accounts exceeds the cost of upgrading.

### Stakeholders and Delivery
- **Jewel Biswas** (Growth) — primary stakeholder for pricing decisions
- **Anurag Bokil** — involved in feature gating analysis
- Deliverables: analysis document, interactive artifact, Excalidraw flow diagrams, Slack draft summary

## Connections
- [[myvoicebooksai-product]] — analytics features may be gated by plan tier in the future
- [[flo-analytics-pipeline]] — Snowflake queries power the business size analysis backing these decisions

## Open Questions
- How should the Platinum-Diamond business size overlap be resolved — sharper feature gates or different pricing anchors?
- What is the churn rate by tier after switching from annual to monthly — does monthly reduce lock-in too much?
- Should analytics (myVoiceBooksAI) be a Platinum/Enterprise feature or a standalone add-on?
- How do competitors (Khatabook, Vyapar) structure their tiers, and where does MBB have pricing power?
- What percentage of Enterprise users actually use compliance features vs. just wanting multi-branch support?
