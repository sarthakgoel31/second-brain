---
title: How Projects Are Born
domains: [#growth, #engineering, #product]
created: 2026-04-10
updated: 2026-04-10
sources:
  - Synthesized from wiki articles: Automation as Lifestyle, 6E Trading System, Biometric Trading Journal, VidText Content Pipeline, Builder Content Strategy, Zero-Cost Architecture, Building with Claude Code, How Sarthak Decides, The Goel Family Builder, Knowledge Compounding, How Sarthak Builds, Trading Discipline and Psychology
---

# How Projects Are Born

The zero-to-one pattern behind every project Sarthak has built. It always starts the same way: a moment of irritation or inspiration, followed by the question "can we build this?", followed by Claude Code building it, followed by a shipped product — often in the same day. The speed is not accidental. It comes from three structural advantages: (1) a stack with zero setup friction (FastAPI + SQLite + vanilla HTML), (2) the zero-cost constraint eliminating procurement decisions, and (3) Claude Code doing the heavy lifting. Projects that survive their first day get automated (crons), guarded (hooks), given memory (persistence), and specialized (agents). Projects that do not survive stay as scripts in /tmp/ and that is fine.

## Key Insights

- Every project starts with irritation or inspiration — never with a business plan, a Jira ticket, or a design doc
- The question is always "can we build this?" — not "should we build this?" The bias is toward action.
- Claude Code + zero-friction stack means the answer to "can we build this?" is almost always yes, today
- Projects that stick go through a maturation pipeline: irritation --> script --> project --> dashboard --> cron --> self-healing system
- Projects that do not stick stay as scripts in /tmp/ — the system does not punish failed experiments
- The zero-cost constraint is an accelerant, not a brake: no procurement, no approval, no vendor evaluation, no invoices
- The "automate on second occurrence" rule is how projects get born: if you do something twice manually, the second time you write code

## Details

### The Birth Stories

Each project has a specific origin moment. None started with planning.

**6E Trading Console:**
Sarthak asked Claude for trading levels every morning. After the second or third time, the thought was: "why not build a dashboard that computes these automatically?" The trading console at `localhost:8420` was shipped in 1 day — 9 files, 1200 lines, FastAPI + WebSocket + mega engine + 5 tabs + Chart.js. It now runs a 5-minute clock-aligned auto-scan, pushes updates via WebSocket, and includes sentiment from 4 sources. The origin was not "I need a trading platform." It was "I am tired of asking Claude the same question every morning."

**Second Brain:**
Sarthak saw Karpathy's tweet about using LLMs to compile personal knowledge bases. The thought: "can we build this for my stuff?" The system — 20+ wiki articles, full schema, ingest/compile/query/lint pipeline — was shipped in a single session. The origin was a tweet that resonated, not a planned project.

**Biometric Trading Journal:**
"I wear an Apple Watch. Can I measure stress while trading?" That single question led to a full trading journal with Apple Watch data bridge (HealthKit --> HTTP POST via iPhone Shortcut), a FastAPI backend at `localhost:8430`, an analysis engine detecting tilt and overconfidence, and SQLite storage for every session. Shipped in 1 day.

**Zen Mode:**
During long Claude Code sessions, Sarthak wanted meditation breaks. The thought: "can we build this into the workflow?" The result: a full meditation system with 9 nature themes, 171 ElevenLabs-generated voice files, real Pexels video backgrounds, Do Not Disturb integration, and a PostToolUse hook that triggers randomly (12% chance, 25-minute cooldown). Shipped in 1 day.

**VidText (Content Listener):**
Sarthak wanted to batch-process YouTube channels for insights — transcribe multiple videos, summarize based on a specific objective, extract actionables. The result: a Python backend (port 8420), a CLI agent, and a Chrome extension with Capture/Batch/Status/History tabs. All running on local Whisper, zero API cost. The Chrome extension turns any browser tab into a transcription trigger.

**Social Branding Tracker:**
Sarthak checked Instagram reel views twice manually to see how myBillBook's content was performing. On the second check, the thought: "this should be automated." The result: a tracker monitoring 176 reels across IG/YT/FB with monthly cohort analysis, self-healing IG cookies, and a daily 8 AM cron on Railway.

**Claude Paglu:**
Sarthak wanted to build an AI content channel — not reporting on AI, but showing what he builds with AI. The result: a 5-agent content pipeline (manager, content-decoder, scriptwriter, visual-director, trend-scanner) orchestrating daily 60-second Hinglish reels edited with Remotion. Target: 100K followers in 30 days.

**Kedarnath Booking:**
The Goel family planned a Kedarnath + Badrinath yatra for May 2026. Helicopter seats sell out in minutes when bookings open. The government announces openings unpredictably. The thought: "we need a monitor." The result: a multi-layer automation with hourly cloud triggers, 5-minute local launchd checks, midnight IST burst scans, and notifications via ntfy.sh, Slack, iMessage, and email. Running since March 26.

### The Pattern

Every birth story follows the same sequence:

```
1. Irritation (repetitive task) or Inspiration (new possibility)
2. "Can we build this?"
3. Claude Code + zero-friction stack builds it
4. Shipped same day
```

Step 2 is the critical moment. The answer is almost always "yes" because:
- The stack (FastAPI + SQLite + HTML) has zero setup friction
- The zero-cost constraint means no procurement approval needed
- Claude Code writes 80%+ of the code
- Dark theme + Chart.js + Inter font are reused from the last project
- No React, no webpack, no npm — just Python and a browser

### The Maturation Pipeline

Not all projects mature equally. The pipeline from birth to self-healing system has distinct stages:

**Stage 1: Script**
A Python script that solves the problem once. Lives in the project folder or sometimes /tmp/. Example: a one-off Instagram scrape.

**Stage 2: Project**
The script earns a directory, a README, and git tracking. It has structure (backend, frontend, config). Example: the social tracker getting its own repo.

**Stage 3: Dashboard**
A single HTML file provides a visual interface. Chart.js for data, vanilla JS for interaction, dark theme for aesthetics. Example: the trading console's 5-tab interface.

**Stage 4: Cron**
The project runs without human triggering. Launchd on macOS, cloud triggers on Railway, scheduled tasks on AWS. Example: social tracker's daily 8 AM refresh.

**Stage 5: Self-Healing System**
The project handles its own failures. Self-healing IG cookies, Snowflake retry with backoff, YouTube 429 fallback to Whisper, Windows Firewall Start/Stop shortcuts. Example: the social tracker detecting expired cookies and auto-refreshing.

**Stage 6: Agent-Backed System**
The project gets Claude agents for specialized tasks. Schema-editor-agent for flo-analytics, 4 agents for trading, 5 agents for Claude Paglu. Example: trading-monitor's data-fetch + levels + validator + sierra-study-builder agent chain.

Not every project reaches Stage 6. Many stay at Stage 3 (dashboard) or Stage 4 (cron) and that is fine. The pipeline is not a mandate — it is a natural evolution driven by how much the project is used.

### What Survives and What Doesn't

Projects that survive their first week share these traits:
- **Daily use:** The trading console, the progress tracker, the social tracker are used every day
- **Growing scope:** The trading console gained tabs, sentiment, replay mode. VidText gained a Chrome extension and Kindle delivery.
- **Automation potential:** If it can be cronned, it stays. If it requires manual triggering every time, it fades.
- **Personal pain:** Projects solving Sarthak's own problems survive. Theoretical projects do not.

Projects that do not survive are not failures. They are experiments that answered "can we build this?" with "yes, but it doesn't solve a real problem." They stay as scripts and that is fine. The cost of the experiment was one Claude session — there is no sunk cost to protect.

### Why Speed Matters

The same-day shipping pattern is not about impatience. It is about momentum. A project shipped today gets used tomorrow. A project that takes a week to set up might never get used — the irritation that motivated it fades, the inspiration cools. Sarthak's stack is deliberately optimized to keep the gap between "can we build this?" and "it's running" as short as possible.

The speed also matters because of the zero-cost constraint. There is no vendor to evaluate, no pricing page to compare, no procurement form to fill. The decision space is: "Python FastAPI or Python Flask?" and the answer is always FastAPI. This elimination of decision fatigue is itself an accelerant.

## Connections

- [[automation-as-lifestyle]] — Stage 4 (cron) and Stage 5 (self-healing) of the maturation pipeline are where automation-as-lifestyle lives
- [[how-sarthak-builds]] — the stack (FastAPI + SQLite + HTML) that makes same-day shipping possible
- [[zero-cost-architecture]] — the zero-cost constraint is an accelerant for project birth: no procurement, no approval
- [[building-with-claude-code]] — Claude Code is the force multiplier at Step 3: it writes 80%+ of the code
- [[6e-trading-system]] — born from "I'm tired of asking Claude for levels every morning"
- [[biometric-trading-journal]] — born from "I wear an Apple Watch, can I measure stress while trading?"
- [[vidtext-content-pipeline]] — born from "I want to batch-process YouTube channels for insights"
- [[builder-content-strategy]] — born from "I want to show what I build, not what I read about"
- [[how-sarthak-decides]] — Pattern 5 (automate on second occurrence) is the trigger mechanism for project birth
- [[the-goel-family-builder]] — the builder identity: "build it, don't just talk about it" is why the answer to "can we build this?" is always "yes"
- [[trading-discipline-and-psychology]] — the patience to wait for the right trade mirrors the impatience to ship when the irritation is real
- [[knowledge-compounding]] — each new project benefits from patterns established in previous projects: the stack, the theme, the agents
- [[direct-sql-vs-llm-pipeline]] — architectural lessons from one project (MVB) transfer to the next project (trading console)
- [[schema-design-as-leverage]] — mature projects earn schemas (trading rules, SQL generation rules, wiki rules) that compound their quality
- [[lessons-from-failures]] — every failure in the maturation pipeline strengthens the next project with a new hook, rule, or agent

## Open Questions

- Is there a threshold where the number of active projects becomes a maintenance burden that prevents new projects from being born?
- Could the birth-to-maturation pipeline be formalized into a `/birth` skill that scaffolds new projects with the standard stack?
- What killed the projects that stayed in /tmp/ — was it always "no daily use" or are there other patterns?
- Is there a maximum sustainable number of Stage 4+ (cronned) projects before the automation infrastructure itself needs automation?
- Should the "automate on second occurrence" rule be "automate on THIRD occurrence" to filter out one-off curiosities?
- What would happen if the zero-cost constraint were removed — would projects be born faster or slower?
