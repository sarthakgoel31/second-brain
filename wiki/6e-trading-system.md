---
title: 6E Trading System
domains: [#trading, #engineering]
created: 2026-04-10
updated: 2026-04-10
sources:
  - memory/project_trading_monitor_status.md
  - memory/project_trading_monitor_agents.md
  - memory/project_trading_console.md
  - memory/feedback_6e_pip_value.md
  - memory/feedback_trading_levels_format.md
  - memory/feedback_sierra_source_of_truth.md
  - memory/reference_sierra_data_fetch.md
---

# 6E Trading System

A fully engineered 6E Euro FX futures trading system built around the DH|S2 (Delta-Hero Scanner v2) strategy. The system spans a Python backtest engine, a FastAPI + WebSocket trading console, Sierra Chart ACSIL C++ studies for live execution, and a 4-agent Claude Code architecture for data fetch, level computation, validation, and study generation. The core philosophy: automate everything except the final decision to click the button.

## Key Insights
- DH|S2 strategy uses delta direction + cumulative delta momentum + VWAP alignment + ATR filter + confluent level proximity as entry conditions
- 6E full-size contract = **$12.50/pip** (NOT $6.25 — that is E7 mini). This distinction matters for all P&L calculations
- The mega engine's `precompute()` function is the single source of truth for levels, RSI, ATR, delta, VPOC/TPOC — everything downstream reads from it
- Sierra Chart study is THE source of truth for live signals — Python must match Sierra's filters exactly, not the other way around
- Sentiment weighting: Scotia FX Daily 35%, TradingView 35%, News 25%, Reddit 5%

## Details

### Strategy: DH|S2

**Entry conditions (all must be true):**
- Delta confirms direction: delta > 0 for long, delta < 0 for short
- Cumulative delta momentum: last 6 bars accelerating vs previous 5 bars
- VWAP aligned with trade direction
- ATR > 2 pips (filters out dead sessions)
- Confluent level within 0.5x ATR of price (levels with 2+ confluences = important, 3+ = ultra-important)

**Exit rules:**
- Stop loss: 1x ATR
- Trailing stop: 0.5x ATR (evaluated at bar close, not tick-by-tick)
- Hard time cut: 12:00 IST
- Maximum hold: 30 bars

### Backtest Results
- 436 trades over 9 months
- 62% win rate
- Profit factor: 9.2
- +$35K at $6.25/pip (original calculation) — actual value at correct $12.50/pip is significantly higher
- Originally computed with E7 mini pip value; correcting to full-size 6E doubles the dollar P&L

### Trading Console
- Runs at `localhost:8420`
- FastAPI backend + WebSocket for real-time updates
- Single HTML frontend (no React, no build step)
- Mega engine precompute() feeds all panels: levels, delta, sentiment, trade plan

### Sentiment Engine
| Source | Weight | Notes |
|---|---|---|
| Scotia FX Daily | 35% | Institutional research, parsed daily |
| TradingView | 35% | Community technical consensus |
| News (Google) | 25% | Event-driven macro signals |
| Reddit | 5% | Retail noise, contrarian indicator |

### Agent Architecture
| Agent | Responsibility |
|---|---|
| data-fetch-agent | Pull Sierra .scid tick data from Windows PC via HTTP |
| levels-agent | Compute daily levels, classify by confluence count |
| trade-validator-agent | Compare Python backtest vs Sierra study output trade-by-trade |
| sierra-study-builder-agent | Generate C++ ACSIL study from validated Python strategy |

### Infrastructure
- Windows PC at `192.168.1.15` running Sierra Chart
- Data fetch via HTTP with `--bind 0.0.0.0` (requires temporary Windows Firewall disable)
- HTTP Range requests for incremental .scid fetch (not full 67MB each time)
- Sierra DH_Scanner study at v11 after 12 hard-won debugging iterations

## Connections
- [[trading-discipline-and-psychology]] — the system is only half the edge; discipline and psychology are the other half
- [[sierra-chart-hard-won-learnings]] — 12 specific debugging lessons encoded from DH_Scanner v1 through v11
- [[knowledge-compounding]] — each backtest iteration, each Sierra bug fix compounds into a more robust system

## Open Questions
- Should sentiment weights be dynamic (increase news weight during NFP/ECB weeks)?
- Is 30-bar max hold optimal, or does extending to 45 bars capture more of the winning tails?
- Can the mega engine precompute() be made incremental to reduce console refresh latency?
- What is the actual corrected dollar P&L at $12.50/pip across all 436 trades?
