---
title: Social Tracker SaaS
domains: [#product, #engineering, #business]
created: 2026-05-01
updated: 2026-05-01
sources:
  - memory/project_social_tracker_saas.md
  - memory/project_mbb_social_branding_tracker.md
---

# Social Tracker SaaS

Rebuilt from a single-tenant MBB internal tool to a public multi-tenant SaaS. Tracks YouTube, Facebook, and Instagram reel views over time with monthly cohort analysis. Free trial (5 URLs, no login), free tier (20 URLs, YT+FB), paid tier (Instagram).

## Key Insights

- Trial-before-signup is critical: let users add 5 URLs and see results before asking for login
- Instagram scraping is the paid moat — YouTube and Facebook are free to track
- YouTube HTML scraping fails on cloud servers (bot detection) — Invidious API is the free workaround
- Add URL should be instant (no scraping) — scraping happens on Refresh click
- Per-IP in-memory trial data (wiped on restart) is fine — it pushes signup
- `const supabase` shadowing `window.supabase` CDN global was a nasty JS bug — rename client variables

## Details

### Architecture

Python FastAPI on Render (free). Supabase Postgres for auth + data. Static HTML frontend with Supabase JS SDK for auth. UptimeRobot pings /api/health to prevent Render spindown.

### Tier Model

| Tier | URLs | Platforms | Auth |
|------|------|-----------|------|
| Trial | 5 | YT + FB | None (per-IP) |
| Free | 20 | YT + FB | Email/password |
| Paid | Unlimited | YT + FB + IG | cal.com booking |

### YouTube Scraping on Cloud

YouTube blocks cloud server IPs. The fallback chain:
1. HTML scraping (`/shorts/{id}` endpoint) — works for some videos
2. Invidious API (free YouTube proxy) — tries 4 instances, no auth needed
3. yt-dlp — blocked on Render ("sign in to confirm you're not a bot")

## Connections

- [[zero-cost-architecture]] — Render free + Supabase free + Invidious free
- [[trial-to-paid-patterns]] — 5 URL trial → signup → 20 URL free → paid IG
- [[how-projects-are-born]] — started as MBB team's spreadsheet replacement, evolved into SaaS
- [[llm-fallback-chains]] — same pattern applied to scraping: try multiple sources until one works

## Open Questions

- Should we add TikTok tracking?
- Can we do automated weekly email reports for paid users?
