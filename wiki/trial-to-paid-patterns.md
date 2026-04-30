---
title: Trial-to-Paid Conversion Patterns
domains: [#product, #business, #growth]
created: 2026-05-01
updated: 2026-05-01
sources:
  - memory/project_social_tracker_saas.md
  - memory/project_archana_conversion_sprint.md
---

# Trial-to-Paid Conversion Patterns

Patterns for converting free users to paid across Sarthak's products. The core insight: let users experience value before asking for anything, then gate the expensive/differentiated feature.

## Key Insights

- **Trial without login** is the highest-converting entry point — zero friction to first value
- Gate the **expensive feature** (IG scraping costs server resources), not the basic one
- Show locked features visually ("Paid only" badge) so users know what they're missing
- Inline upgrade CTAs (not separate pages) — Archana's subscription toggle on checkout, Social Tracker's "Unlock" button in the table
- The CTA should be a **personal cal.com link**, not a Stripe checkout — for early-stage products, a call converts better than self-serve
- Limits (5 URLs trial, 20 URLs free) create natural upgrade moments without feeling punitive

## Details

### Social Tracker Funnel

```
Visit → Add 5 YouTube URLs (no login) → See views → Hit 6th URL → "Sign up free"
→ Add 20 URLs (free) → Want Instagram → "Book a call" → Paid
```

### Archana Funnel

```
Browse poojas → See prices + temple details → Book (Razorpay) → Photo proof delivered
→ Trust established → Subscription toggle on checkout → Monthly pooja plan
```

### Anti-Patterns

- Don't pop login modals on every action — only at the actual limit
- Don't hide features entirely — show them locked so users know what's possible
- Don't require payment info for free tier — email/password is enough

## Connections

- [[social-tracker-saas]] — 5/20/unlimited tier model implementation
- [[archana-pooja-platform]] — subscription inline on checkout
- [[zero-cost-architecture]] — free tiers must actually cost zero to serve
- [[mbb-pricing-architecture]] — FloBiz's feature gating approach at scale

## Open Questions

- At what scale does self-serve checkout replace cal.com?
- Should trial data migrate to account on signup?
