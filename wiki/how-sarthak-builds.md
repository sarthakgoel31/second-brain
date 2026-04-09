---
title: How Sarthak Builds
domains: [#engineering, #growth]
created: 2026-04-10
updated: 2026-04-10
sources:
  - Synthesized from wiki articles: Zero-Cost Architecture, Building with Claude Code, 6E Trading System, myVoiceBooksAI Product, Direct SQL vs LLM Pipeline, VidText Content Pipeline, Automation as Lifestyle, The Goel Family Builder
---

# How Sarthak Builds

The engineering philosophy behind every project Sarthak ships. Not what he builds, but the specific technical patterns he reaches for every time: single HTML files instead of React, FastAPI + SQLite instead of Rails + Postgres, vanilla JS instead of npm, WebSocket instead of polling, and a dark theme that never changes. These are not random preferences — they are a stack deliberately chosen to minimize friction between idea and deployment. The result: full products shipped in a single day, from trading consoles to meditation systems, all running at zero cost.

## Key Insights

- The default stack is Python FastAPI + SQLite + vanilla HTML/JS + Chart.js — no build step, no bundler, no framework
- Single HTML file philosophy: trading console, social tracker, MVB dashboard, VidText extension all ship as one HTML file with inline CSS/JS
- "Ship in one session" is not aspirational — the trading console was 9 files, 1200 lines, built and deployed in 1 day
- SQLite over Postgres for everything personal — zero config, file-based, portable, Railway volume mount for production
- WebSocket for live data push (trading console), not polling — the system tells you when something changes
- The mega engine pattern: one `precompute()` function as the single source of truth, everything downstream reads from it
- Dark theme always: `#09090b` base, `#3b82f6` accent, glassmorphism, Inter font — no exceptions, no bright pastels on dark backgrounds
- "Test before showing" is a mechanical habit, not a suggestion — run tsc, vite build, curl before any demo

## Details

### The Stack

Every personal project converges on the same stack:

| Layer | Choice | Why |
|---|---|---|
| Backend | Python FastAPI | Async, minimal boilerplate, native WebSocket support |
| Database | SQLite | Zero config, file-based, `.db` file is the entire database |
| Frontend | Single HTML file | No build step, no npm, no React, no webpack — open in browser and it works |
| Charts | Chart.js | Lightweight, works from CDN, no build pipeline needed |
| Real-time | WebSocket | Push from server, not pull from client — lower latency, less wasted compute |
| Hosting | Railway / Render free tier | Zero cost, git push to deploy |

This stack has a specific property: **zero setup friction**. There is no `npm install`, no `vite.config.js`, no `tsconfig.json`, no `.babelrc`. You write Python, write HTML, and run. The time from idea to working prototype is measured in minutes, not hours.

The stack applies to personal projects. FloBiz work uses whatever the team uses (Node/Express for MVB, Python for data-crons). But when Sarthak has full control, it is always this stack.

### Single HTML File Philosophy

The trading console at `localhost:8420` is a single HTML file. The social branding tracker is a single HTML file. The MVB dashboard frontend is a single HTML file. VidText's Chrome extension popup is a single HTML file. Zen mode's meditation player is a single HTML file.

Why this works:
- No build step means no build failures
- View source shows everything — nothing hidden in node_modules
- Deployable by copying one file
- Inline CSS means no FOUC (flash of unstyled content)
- Chart.js, Inter font, and any library loaded from CDN
- The constraint forces simplicity — if it does not fit in one file, the scope is too big

The exception: when a project matures past the prototype stage (flo-analytics-llm SDK, Remotion video pipeline), it earns a real build system. But the default is always no-build.

### Ship in One Session

These are not toy demos. They are complete, usable products:

| Project | Scope | Time |
|---|---|---|
| 6E Trading Console | FastAPI + WebSocket + mega engine + 5 tabs + Chart.js | 1 day (9 files, 1200 lines) |
| Zen Mode | 9 themes, 171 ElevenLabs voice files, video backgrounds, DND integration | 1 day |
| Second Brain | 20 wiki articles, full schema, ingest/compile/query/lint pipeline | 1 session |
| Biometric Trading Journal | Apple Watch bridge, FastAPI backend, analysis engine, SQLite storage | 1 day |
| Social Branding Tracker | IG/YT/FB scraping, self-healing cookies, 176 reels, Railway deploy | ~1 day |

Speed comes from three things: (1) the stack has zero setup friction, (2) the zero-cost constraint eliminates procurement decisions, and (3) Claude Code does the heavy lifting. There is no "set up the development environment" phase. You just start building.

### SQLite Over Postgres

For personal projects, SQLite wins on every axis:
- **Zero config:** No `docker-compose.yml`, no connection strings, no user/password
- **File-based:** The database is a `.db` file. Back it up by copying the file. Deploy it by including the file.
- **Railway volume mount:** Railway's free tier lets you mount a persistent volume where the SQLite file lives
- **Portable:** Move the entire project by moving the folder. The database comes with it.
- **Good enough concurrency:** Personal projects have one user (Sarthak). SQLite's write lock is irrelevant.

Postgres is for when you have multiple concurrent writers, need full-text search at scale, or have a team. None of these apply to personal projects.

### WebSocket for Live Data

The trading console does not poll. The server pushes updates via WebSocket when the mega engine recalculates (every 5 minutes, clock-aligned). The client connects once and listens. This is fundamentally different from `setInterval(fetch, 5000)`:
- No wasted requests during idle periods
- Instant updates when data changes
- The server controls the cadence, not the client
- Lower total network traffic

### The Mega Engine Pattern

The `precompute()` function in the trading console is the clearest example: one function runs every 5 minutes, computes ALL derived data (levels, delta, RSI, ATR, VWAP, VPOC, TPOC, sentiment, trade plan), and stores it in a single state object. Every endpoint, every WebSocket message, every UI panel reads from this precomputed state. Nothing computes on-the-fly.

This same pattern appears elsewhere:
- **MVB Dashboard:** Direct SQL queries precompute 8 metrics on load. The chat panel reads from the same Snowflake connection.
- **Social Tracker:** Daily cron precomputes view counts for all 176 reels. The UI just reads the latest snapshot.
- **Second Brain:** Wiki articles are precompiled from raw sources. Queries read the compiled wiki, not the raw material.

The principle: **compile once, query many times.** Burn compute at write time so read time is instant.

### Dark Theme Always

The visual identity is consistent across every project:
- **Base:** `#09090b` (near-black)
- **Accent:** `#3b82f6` (deep blue — never bright/pastel like `#38bdf8`)
- **Glass:** Glassmorphism panels with `backdrop-filter: blur()`
- **Font:** Inter (loaded from Google Fonts CDN)
- **Principle:** No bright accents on dark backgrounds. Deeper blues, muted tones. The UI should feel premium and calm, not flashy.

This is a hard rule, not a preference. The feedback memory explicitly states: "No bright/pastel accents on dark UIs — use deeper blues (#3b82f6 not #38bdf8)."

### Test Before Showing

The rule is mechanical: before telling the user (or yourself) that something works, verify it:
- `tsc` for TypeScript projects
- `vite build` or `npm run build` for anything with a build step
- `curl localhost:PORT/endpoint` for API endpoints
- Open the HTML file in a browser and click through
- Run the Python script and check the output

This rule exists because showing broken UI destroys trust. It was learned the hard way on the MVB dashboard — a demo where the scroll was broken and the timing was off. The cost of fixing the trust was higher than the cost of the 10 seconds it would have taken to test first.

## Connections

- [[zero-cost-architecture]] — the zero-cost constraint is WHY this stack exists: no paid tooling, no SaaS dependencies, no build infrastructure to maintain
- [[building-with-claude-code]] — Claude Code is the force multiplier that makes single-session shipping possible: one person + AI = team-scale output
- [[6e-trading-system]] — the mega engine precompute() pattern originated here and spread to every other project
- [[direct-sql-vs-llm-pipeline]] — the "compile once, query many" principle is the same as precompute(): do the expensive work upfront
- [[myvoicebooksai-product]] — Dark Frost theme, the Snowflake connection singleton, and the dashboard's direct SQL queries all follow these patterns
- [[vidtext-content-pipeline]] — FastAPI + SQLite + Chrome extension = the stack in action for content tooling
- [[automation-as-lifestyle]] — the self-healing patterns (IG cookies, Snowflake retry) layer on top of this stack
- [[the-goel-family-builder]] — these engineering patterns are expressions of a deeper value: build things, don't just talk about them
- [[how-sarthak-decides]] — Pattern 2 (architectural thinking before implementation) explains why the stack is so consistent
- [[schema-design-as-leverage]] — the mega engine's precomputed state IS a schema: a structured representation that everything else reads from
- [[knowledge-compounding]] — the stack itself compounds: every new project benefits from the same patterns, libraries, and muscle memory

## Open Questions

- At what point does the single HTML file need to break into components — is there a line count or feature count threshold?
- Should the stack evolve to include HTMX for server-driven interactivity, or does vanilla JS + WebSocket cover all cases?
- Is there a version of this stack that works for collaborative projects where others need to contribute?
- Could the mega engine pattern be extracted into a reusable library (`precompute-engine`) that all projects import?
- What happens when a personal project succeeds and needs to scale beyond SQLite — is there a graceful migration path?
