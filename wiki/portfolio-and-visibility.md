---
title: Portfolio & Visibility Strategy
domains: [#growth, #content, #business]
created: 2026-05-01
updated: 2026-05-01
sources:
  - memory/project_portfolio_goal.md
  - memory/project_portfolio_status.md
  - memory/project_social_poster.md
---

# Portfolio & Visibility Strategy

Hardeep (friend, hardeep.cv) got 3 paid projects from Reddit and Twitter posting. Sarthak has 30+ projects and zero posts. The gap isn't building — it's visibility. The portfolio exists (sarthakgoel.cv), the posting tool exists (social-poster), the products are live. What's missing: actually posting.

## Key Insights

- Building more projects doesn't get you paid projects — posting about them does
- Reddit long-form posts (r/webdev, r/SideProject) convert better than Twitter for dev tools
- Case study pages (mvb.sarthakgoel.cv, flo.sarthakgoel.cv) are for credibility, not direct traffic
- Live products (audit.sarthakgoel.cv, social-tracker.sarthakgoel.cv) are the best portfolio pieces — "try it yourself"
- Subdomain architecture (*.sarthakgoel.cv) makes each project look independent and professional
- README quality directly correlates with GitHub stars — Why→How→Features→Tech→Architecture→Status format

## Details

### Current Portfolio (12 projects on sarthakgoel.cv)

1. myVoiceBooksAI → case study with animated chat demo
2. Flo Analytics → case study
3. Archana → live product
4. Site Auditor → live product
5. Zen Mode, Social Tracker, ToyHype, Second Brain, Kindle Agent, Morning Coffee, HisaabBot, Pulse Check

### Posting Tool (social-poster)

Python CLI: `python -m src list/generate/reddit/post`. 9 projects configured with subreddit targeting and tone. Reddit = clipboard (manual paste), X = automated via Tweepy (@AnotherSarthak).

### What's Still Missing

- Zero posts published (tool ready, content generated, never sent)
- README polish on top repos
- Portfolio photos (gradient placeholders on About sections)

## Connections

- [[builder-content-strategy]] — "I build with AI" over clickbait
- [[how-projects-are-born]] — the projects exist, they just need exposure
- [[zero-cost-architecture]] — all hosting is free, so there's no burn while building visibility

## Open Questions

- Which project gets the first Reddit post? (Site Auditor or Archana?)
- Should we post on Hacker News or is the audience wrong?
- Should portfolio be a Next.js app or a simple static page?
