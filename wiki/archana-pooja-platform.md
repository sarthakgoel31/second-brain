---
title: Archana — Trust-First Pooja Booking
domains: [#product, #engineering, #business, #growth]
created: 2026-05-01
updated: 2026-05-01
sources:
  - memory/project_archana.md
  - memory/project_archana_deployed.md
  - memory/project_archana_kundli_feature.md
  - memory/project_archana_conversion_sprint.md
---

# Archana — Trust-First Pooja Booking

Most Indians want to book poojas online but trust is the barrier. Archana solves this with photo proof delivery, daily Panchang, Kundli birth charts, and auto-refund via Razorpay. 20 database migrations, admin dashboard, full email lifecycle. Zero paid APIs — all computation runs locally. Sarthak's most exciting project, potential startup.

## Key Insights

- Trust is the #1 barrier in online pooja booking — not price, not selection
- Photo proof of the pooja happening is the single biggest trust signal
- Auto-refund via Razorpay on admin cancel removes all purchase risk
- Panchang/horoscope engine uses independent rotation pools for 5K+ combos per rashi — zero API cost
- Birth nakshatra is optional, never blocking the booking funnel
- Subscription model (monthly pooja packages) has higher LTV than one-time bookings
- SEO pipeline: 50 blogs with date-gated auto-publish, zero cost

## Details

### Architecture

Full-stack Next.js on Vercel, Supabase Postgres, Razorpay payments, Resend emails, Cloudinary images. All services on <your-email>. Live at myarchana.in since 2026-04-12.

### Conversion Optimization

Three waves of conversion work: consolidation (removing friction), pricing visibility (showing prices on cards), and CTAs (urgency badges, social proof, nav grah CTAs, gift-a-pooja). Every wave measured against Vercel Analytics + GA4.

### The Kundli Feature

Birth chart engine with pandit chatbot. User enters DOB → gets rashi, nakshatra, planetary positions. Chatbot answers questions about their chart. Never shows pooja upsells in initial answer — only inside expanded detail.

## Connections

- [[zero-cost-architecture]] — all computation local, no paid APIs
- [[how-projects-are-born]] — started from wanting to book a pooja online and finding no trustworthy option
- [[how-sarthak-decides]] — constraint-first: every feature must work on Vercel free tier
- [[trial-to-paid-patterns]] — subscription toggle inline on checkout, zero extra steps

## Open Questions

- Can influencer reels drive enough traffic to hit ₹50K MRR?
- Should i18n (Hindi/regional) be next, or focus on SEO traffic first?
- Temple partnerships: QR code posters at temples — will they convert?
