---
title: Zero-Cost Architecture
domains: [#engineering, #growth, #business]
created: 2026-04-10
updated: 2026-04-10
sources:
  - feedback_no_paid_apis.md
  - project_hosting_plan.md
  - project_content_listener.md
  - project_claude_paglu.md
  - project_trading_monitor_status.md
  - project_mbb_social_branding_tracker.md
---

# Zero-Cost Architecture

Sarthak's foundational constraint for all personal projects: zero paid APIs, zero financial investment. This is not frugality for its own sake — it is a design philosophy where cost constraints force creative engineering solutions. Every feature must find a free path, and when one doesn't exist, you build the path yourself.

## Key Insights
- The constraint "we cannot invest money in this project" is a hard rule, not a guideline
- Free-tier limits breed ingenuity — self-healing cookies, local models, extractive summarization, RSS scraping
- Every paid API has a free alternative if you're willing to do the engineering work
- The escape hatch exists (Render paid at $7/mo for always-on) but remains deliberately unused
- Cost-zero does not mean quality-zero — the products work, ship, and serve real users

## Details

### Hosting & Infrastructure
- **Render.com free tier**: Auto-deploy from GitHub for backend services. Cold starts are the price you pay — UptimeRobot pings keep services warm with scheduled health checks.
- **Railway**: Used for insta-tracker where SQLite persistence needs free volume storage.
- **Netlify**: Frontend artifact hosting for shared HTML pages.
- **Escape hatch acknowledged**: Render's $7/mo always-on tier is known but intentionally not used. The moment you pay for one thing, the discipline unravels.

### AI & LLM Calls
- **Grok**: Available through FloBiz work account — free for work-adjacent projects like flo-analytics-llm.
- **Gemini Flash**: Google's free tier considered as a pipeline speedup (10s vs 20-25s with dual Grok calls).
- **Local summarization**: `local_summarize` uses extractive summarization when no ANTHROPIC_API_KEY is present — no API call needed, just tf-idf and sentence scoring.
- **Whisper (local)**: Transcription runs on-device. Smart model selection picks the smallest model that will produce acceptable quality for the audio length.

### Content & Media
- **yt-dlp subtitles**: Grab existing YouTube subtitles before falling back to Whisper transcription — free and faster.
- **Remotion**: Open-source programmatic video editing for claude-paglu reels. No Adobe, no subscription.
- **CapCut free tier**: Fallback video editing when Remotion isn't the right fit.
- **ManyChat free tier**: Growth automation for content distribution.

### Data & Sentiment
- **Scotia FX Daily PDF**: Free daily forex analysis PDF, parsed for EUR/USD sentiment.
- **Google News RSS**: Free news feed for market sentiment scanning.
- **TradingView Technical Analysis**: Free widget/API for technical indicators.
- **Reddit RSS**: Free subreddit monitoring for retail sentiment on 6E/DXY.

### Creative Engineering Workarounds
- **Self-healing Instagram cookies**: The MBB Social Branding Tracker avoids paying for Instagram's official API by maintaining and auto-refreshing session cookies. When cookies expire, the system detects and regenerates them.
- **Extractive over abstractive**: When you can't call an LLM, extractive summarization (sentence importance scoring) gives 80% of the value at 0% of the cost.

## Connections
- [[direct-sql-vs-llm-pipeline]] — Direct SQL is another expression of this philosophy: don't burn LLM tokens when a SQL query does the job in 300ms
- [[building-with-claude-code]] — Claude Code itself is the free development multiplier that makes zero-cost architecture viable at this velocity
- [[6e-trading-system]] — Trading monitor's entire sentiment pipeline is built on free data sources

## Open Questions
- At what scale does the free-tier constraint become a bottleneck rather than a creative force?
- Could a $20/month budget unlock disproportionate value without breaking the discipline?
- How do you evaluate the hidden cost of engineering time spent working around paid APIs?
- What's the playbook for migrating from free to paid when a project actually generates revenue?
