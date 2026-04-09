---
title: Biometric Trading Journal
domains: [#trading, #engineering, #growth]
created: 2026-04-10
updated: 2026-04-10
sources:
  - raw/conversations/2026-04-10-trading-journal-biometrics.md
---

# Biometric Trading Journal

Correlating Apple Watch biometric data (heart rate, HRV, sleep) with trading performance to answer: does physiological stress predict worse trading outcomes?

## Key Insights

- Apple Watch can't connect directly to Mac for HealthKit — iPhone Shortcut bridges the gap (HealthKit → HTTP POST to local server)
- Starting an "Other" workout on Apple Watch gives 3-5 second HR granularity vs normal 5-minute intervals — critical for detecting mid-trade stress spikes
- Pre-session readiness score (computed from sleep + resting HR + mood) may predict whether a session will be profitable before it starts
- The analysis engine can detect patterns invisible to the trader: tilt cascades, overconfidence bias, sleep-deprivation errors

## Details

### Data Collected Per Session
- **Pre-session**: mood (1-5), sleep hours, caffeine (y/n), exercise (y/n), readiness score (computed)
- **Biometrics**: HR samples every 3-5s, HRV, sleep data (via Apple Shortcut POST)
- **Per-trade**: direction, prices, pips, outcome, per-plan (y/n), rules broken, confidence (1-5), emotions before/during/after
- **Post-session**: rating (1-5 stars), key lesson, notes

### Analysis Engine Detects
- **Win rate by emotion state** — does anxiety correlate with losses?
- **Win rate by sleep quality** — is there a minimum sleep threshold?
- **Win rate by HR zone** — elevated HR = worse decisions?
- **Tilt detection** — losses followed by emotional entries (revenge trading)
- **Overconfidence detection** — high confidence scores predicting bigger losses
- **Discipline score** — ratio of per-plan trades to total trades

### Architecture Decision: One-Time Sync
Initial design had the shortcut running every 5 minutes. User feedback: "Why are you not thinking properly and practically?" Redesigned to one-time pre-session sync — push sleep/HR before trading starts, then the Apple Watch workout logs continuous HR that can be batch-imported after session ends.

## Connections

- [[6e-trading-system]] — the trading system this journal monitors
- [[trading-discipline-and-psychology]] — the mental models this data validates or challenges
- [[automation-as-lifestyle]] — another example of instrumenting life for self-improvement
- [[how-sarthak-decides]] — Pattern 3 (data over intuition) applied to self-knowledge

## Open Questions

- What's the minimum dataset size before biometric correlations become statistically meaningful?
- Does HRV (autonomic nervous system state) predict trading outcomes better than raw HR?
- Can a "don't trade today" signal be generated from pre-session biometrics alone?
- Should the journal trigger an alert if mid-session HR exceeds a threshold (potential tilt)?
