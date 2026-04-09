---
title: MBB Sales and Data Insights
domains: [#business, #product]
created: 2026-04-10
updated: 2026-04-10
sources:
  - project_mbb_sales_touch_analysis.md
  - project_data_crons_sync_leads.md
  - project_mbb_social_branding_tracker.md
  - reference_leadsquared_api.md
  - reference_data_crons.md
---

# MBB Sales and Data Insights

FloBiz's data infrastructure combines LeadSquared CRM data, Snowflake warehousing, and a suite of Python cron jobs to power sales analysis and product decisions for myBillBook. A key finding from sales touch analysis: the self-serve ratio is nearly identical for new users (53.4%) and renewals (54.5%), challenging the assumption that renewals are more sales-dependent. The data-crons repo, running on AWS, syncs 300+ LSQ fields daily and feeds dashboards, alerts, and analytics across the organization.

## Key Insights
- **Sales Touch vs Self Serve split is remarkably consistent:** renewals at 54.5% self-serve vs new users at 53.4% — the gap is negligible
- Renewals (22 users sampled): 45.5% sales touch, split evenly between inbound and outbound
- New users (2,056 sampled): 46.6% sales touch, with outbound dominant at 56% of sales-touched
- Outbound dominance in new user acquisition suggests the sales team is more hunter than farmer
- sync_leads.py expanded to 300+ LSQ fields — comprehensive lead data now available in Snowflake
- LSQ API uses `mx_Phone_Number_F11` for phone lookups — non-obvious field naming convention
- MBB Social Branding Tracker covers 176 reels across IG/YT/FB with monthly cohort analysis

## Details

### Sales Touch Classification

The analysis (dated 2026-03-30) classified user acquisition into:
- **Self-serve:** User signed up and converted without any recorded sales interaction
- **Sales touch — Inbound (IB):** User initiated contact (demo request, support query) that led to conversion
- **Sales touch — Outbound (OB):** Sales team proactively reached out to the user

The data comes from LeadSquared call logs cross-referenced with Snowflake user records. The classification logic lives in the data-crons repo.

### Data Infrastructure

| Component | Details |
|---|---|
| **Data warehouse** | Snowflake — `LSQ.PUBLIC.LSQ_LEADS` table for lead data |
| **CRM** | LeadSquared — API with phone lookup via `mx_Phone_Number_F11` |
| **Sync job** | `sync_leads.py` — paginated at 10K leads/page, 300+ fields, 8 AM daily cron |
| **AWS instance** | `i-04d28088af7091e22`, `flo` user, accessed via Session Manager |
| **Git remote** | `git@github.com:team-flobiz/data-crons.git` |

### Data-Crons Repository Structure

| Directory | Purpose |
|---|---|
| `data_alerts/management_dashboard/` | MIS reports, revenue tracker, SaaS dashboard, retention |
| `data_alerts/google_sheets/` | Sheet syncs (sales, ARR, renewals, pricing) |
| `data_alerts/renewal_sales/` | Renewal sales scripts |
| `data_alerts/lsq_data/` | LeadSquared data sync |
| `data_alerts/snowflake/` | Snowflake query scripts |
| `integrations/` | Amplitude, CleverTap, Google Ads/Analytics, LSQ, Meta, Snowflake connectors |

### Integrations Ecosystem

The data-crons repo connects to six external platforms:
1. **Amplitude** — product analytics, feature usage, event tracking
2. **CleverTap** — push notifications, user engagement
3. **Google Ads/Analytics** — acquisition attribution
4. **LeadSquared** — CRM, sales pipeline, call logs
5. **Meta** — social ad performance
6. **Snowflake** — central data warehouse

### MBB Social Branding Tracker

A separate system tracking 176 reels across Instagram, YouTube, and Facebook:
- Monthly cohort analysis shows content performance trends over time
- Self-healing Instagram cookies handle auth expiry automatically
- Parallel refresh keeps data current across all three platforms
- Hosted on Railway with daily 8 AM IST cron

## Connections
- [[automation-as-lifestyle]] — The data-crons system and social tracker are prime examples of automated data pipelines
- [[the-goel-family-builder]] — This is Sarthak's day job at FloBiz, the product context behind everything
- [[builder-content-strategy]] — Social branding tracker data could inform Claude Paglu content strategy

## Open Questions
- Why is the self-serve ratio so stable across new and renewal users — is this a product characteristic or a sales team capacity constraint?
- With OB dominant for new users, what's the CAC difference between OB-acquired vs self-serve users?
- Should the 300+ LSQ fields be pruned to what's actually used, or is the full sync valuable for future analysis?
- Can Amplitude event data be cross-referenced with LSQ sales touch to identify which product features drive self-serve conversion?
