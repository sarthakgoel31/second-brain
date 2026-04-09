---
title: Automation as Lifestyle
domains: [#growth, #engineering]
created: 2026-04-10
updated: 2026-04-10
sources:
  - project_kedarnath_booking.md
  - project_night_duty.md
  - project_zen_mode.md
  - project_progress_tracker.md
  - project_mbb_social_branding_tracker.md
  - project_trading_console.md
  - feedback_do_everything.md
---

# Automation as Lifestyle

Sarthak's approach to tooling follows one rule: if you do something twice, automate it. This spans from spiritual logistics (Kedarnath helicopter booking sniper running since March 26) to self-care (Zen meditation auto-triggering during idle Claude sessions) to professional tracking (progress collector scanning git repos and Claude sessions nightly at 11 PM). Every system is designed to be self-healing — IG cookies auto-refresh, Snowflake retries on SQL errors, and trading scans run clock-aligned without manual triggers. The result is a personal infrastructure layer where most recurring tasks happen without human intervention.

## Key Insights
- The Kedarnath booking system has been monitoring the portal since March 26, 2026 — bookings could open any day, and the sniper must be ready the instant they do
- Zen mode triggers randomly (12% chance on PostToolUse hook, 25-minute cooldown) — meditation becomes an ambient part of the workday, not a scheduled chore
- Night duty solves a real problem: long-running Claude tasks that need the Mac awake overnight with the screen dimmed
- Progress tracker uses Claude session logs as a primary source — more accurate than git alone since not all work results in commits
- Self-healing is the pattern that separates "automation" from "scripts that break" — every system must handle its own failures
- The 5-minute clock-aligned trading scan means no manual "check the market" — the system surfaces opportunities

## Details

### Kedarnath Helicopter Booking Automation

The most complex automation — a monitor + sniper system for booking helicopter seats for 7 Goel family members on May 13, 2026 (Phata return route):

| Layer | Mechanism | Frequency |
|---|---|---|
| Cloud triggers | Hourly checks + midnight IST burst | Hourly / daily |
| Local launchd | macOS launch daemon | Every 5 minutes |
| Notifications | ntfy.sh push, Slack, iMessage, email | On availability detected |

The portal has no API — this is pure web scraping with form submission. The sniper must complete booking for all 7 seats in a single session before they sell out. Running since March 26 because the government announces booking windows unpredictably.

### Night Duty

Two capabilities bundled into one skill:
1. **Caffeinate:** Keeps the Mac awake using macOS `caffeinate` command
2. **Blind:** Dims the screen to zero brightness (two-step process because keyboard brightness can't be controlled programmatically)

Used when Claude has long-running overnight tasks — data processing, large builds, or monitoring jobs.

### Zen Mode

A meditation system that integrates into the Claude Code workflow:

- **Trigger:** PostToolUse hook with 12% random activation, 25-minute cooldown between sessions
- **Themes:** 9 nature themes (rain, ocean, forest, mountain, etc.)
- **Media:** Real Pexels videos for each theme, ElevenLabs-generated voice guidance
- **Content:** 76 life lessons rotated through sessions
- **DND:** Automatically enables Do Not Disturb during meditation, restores after
- **Duration:** Configurable, defaults to a short mindfulness break

### Progress Tracker

Nightly at 11 PM IST, the progress tracker:
1. Scans all git repositories for the day's commits
2. Reads Claude session logs to capture non-commit work (research, debugging, planning)
3. Compiles a daily activity digest
4. Can generate weekly summaries and newsletters

The key insight: Claude sessions capture work that git misses — conversations about architecture, debugging sessions, research that doesn't result in code changes.

### MBB Social Branding Tracker

Daily at 8 AM IST:
- Refreshes view counts for 176 tracked reels across IG/YT/FB
- Self-healing IG cookies handle Instagram's aggressive session expiry
- Parallel refresh across platforms keeps the cycle under 2 minutes
- Hosted on Railway — no local machine dependency

### Trading Console

The 6E trading console at localhost:8420:
- Auto-scans every 5 minutes, clock-aligned (not "5 minutes from start" but at :00, :05, :10...)
- Mega engine processes delta, levels, sentiment, and trade plan
- Surfaces actionable signals without requiring manual chart review

### The Self-Healing Pattern

Every automation includes failure recovery:
- **IG cookies:** Auto-refresh when Instagram returns 401
- **Snowflake:** Retry with exponential backoff on SQL errors
- **YouTube transcription:** Falls back to Whisper when subtitle API returns 429
- **Trading data fetch:** Shows troubleshooting steps inline when Windows PC is unreachable

## Connections
- [[the-goel-family-builder]] — The automation mindset is core to Sarthak's identity as a builder
- [[vidtext-content-pipeline]] — VidText's fallback chains are a direct application of self-healing design
- [[builder-content-strategy]] — Each automation is potential MAIN reel content for Claude Paglu
- [[mbb-sales-and-data-insights]] — The data-crons system is the professional-context version of this same pattern
- [[6e-trading-system]] — Trading console auto-scan is automation applied to markets
- [[zero-cost-architecture]] — All automations run on free infrastructure (launchd, Railway free tier, Gmail SMTP)

## Open Questions
- Is there a meta-automation that monitors the health of all other automations and alerts on failures?
- Could the Kedarnath sniper pattern be generalized into a "booking automation framework" for other scarce-ticket scenarios?
- Should Zen mode's 12% trigger rate be adaptive based on stress signals (typing speed, error frequency)?
- What's the total compute cost of all these automations running 24/7 — is it truly zero or just negligible?
