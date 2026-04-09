---
title: Sierra Chart Hard-Won Learnings
domains: [#trading, #engineering]
created: 2026-04-10
updated: 2026-04-10
sources:
  - memory/feedback_sierra_source_of_truth.md
  - memory/project_trading_monitor_status.md
  - memory/project_trading_monitor_agents.md
  - memory/reference_sierra_data_fetch.md
  - memory/project_trading_firewall_fix.md
---

# Sierra Chart Hard-Won Learnings

Twelve specific debugging lessons extracted from building the DH_Scanner ACSIL C++ study across versions 1 through 11. These learnings cost 8+ hours of painful debugging and are now encoded directly into the sierra-study-builder-agent so they never have to be rediscovered. The fundamental principle: Sierra Chart is THE source of truth for live signals. Python exists to validate ideas, but Sierra is what runs in production.

## Key Insights
- Sierra study is the production system — Python backtests must match Sierra's filters, not the other way around
- 8+ hours of debugging produced 12 hard-won learnings that are now baked into agent instructions
- The trade-validator-agent exists specifically to catch Python-Sierra divergence trade-by-trade
- Data fetch uses HTTP Range requests for incremental .scid retrieval (avoids re-downloading 67MB)
- Every Sierra study version (v1-v11) fixed a specific class of bug; the progression tells a story

## Details

### The Source of Truth Principle

When Python backtest results and Sierra study results disagree, **Sierra is correct**. This is counterintuitive — Python feels more debuggable, more transparent. But Sierra is what executes live. If Python says "trade here" and Sierra does not, the fix is in Python, not Sierra. This principle was learned the hard way after multiple cycles of "fixing" Sierra to match Python, only to introduce new bugs.

### The 12 Hard-Won Learnings

These are the specific debugging lessons from DH_Scanner v1 through v11:

1. **UTC date handling** — Sierra uses UTC internally. Comparing dates without accounting for timezone offset causes phantom signals at session boundaries. Always convert to exchange time before date comparisons.

2. **Bar-close trailing stop** — Trail must be evaluated at bar close, not on every tick. Tick-by-tick trailing gets stopped out by noise wicks that bar-close trailing survives. This single change dramatically improved backtest results.

3. **Entry bar skip** — Never evaluate exit conditions on the same bar as entry. The entry bar's high/low often triggers an immediate stop-out that would not occur with proper bar-close evaluation.

4. **Drawing cleanup** — Sierra accumulates chart drawings (lines, markers) from previous study runs. If the study does not explicitly delete old drawings on recalculation, the chart becomes unusable. Always clean up in the `sc.UpdateStartIndex` block.

5. **Alert spam prevention** — Without deduplication, alerts fire on every recalculation for the same signal. Use a persistent variable to track the last alert bar index and only fire once per signal.

6. **Persistent variable initialization** — Sierra persistent variables (`sc.GetPersistentInt()`, etc.) retain values across recalculations. If not properly initialized on first run, stale values from a previous session cause ghost signals.

7. **Subgraph buffer sizing** — Subgraph arrays must match the chart's bar count. Off-by-one errors cause silent memory corruption that manifests as random crashes hours later.

8. **Multi-timeframe data alignment** — When referencing a higher timeframe (e.g., daily levels on a 5-min chart), the bar index mapping is not 1:1. Use `sc.GetContainingIndexForDateTimeIndex()` to align correctly.

9. **Float comparison precision** — Comparing price levels with `==` fails due to floating-point precision. Always use epsilon comparison (`fabs(a - b) < 0.00005` for 6E's tick size).

10. **Study input ordering** — Reordering study inputs in code changes their mapping in Sierra's UI. Users who had configured inputs find them scrambled. Never reorder — only append new inputs at the end.

11. **sc.FreeDivisor for proper scaling** — Delta and cumulative delta values can overflow subgraph display ranges. Use `sc.FreeDivisor` or explicit scaling to keep visual output readable.

12. **DLL hot-reload behavior** — Sierra caches compiled DLLs aggressively. After recompiling, the old DLL may still be loaded. Force a reload by removing the study from the chart and re-adding it, or restart Sierra.

### Agent Architecture for Sierra Development

| Agent | Role in Sierra Workflow |
|---|---|
| sierra-study-builder-agent | Generates C++ ACSIL code from validated Python strategy; all 12 learnings are encoded as hard constraints |
| trade-validator-agent | Runs Python backtest and compares trade-by-trade against Sierra study output; flags divergences |
| strategy-lab-agent | Tests new strategy ideas on Sierra tick data before they reach the study builder |
| data-fetch-agent | Pulls .scid tick data from Windows PC via HTTP Range requests (incremental, not full file) |

### Workflow: Idea to Live Study

```
strategy-lab-agent (new idea)
    → Python backtest on .scid data
    → trade-validator-agent (compare vs existing Sierra output)
    → sierra-study-builder-agent (generate C++ with all 12 learnings)
    → compile + deploy to Sierra Chart
    → trade-validator-agent (verify new Sierra output matches Python)
```

### Data Fetch Infrastructure

- Windows PC at `192.168.1.15` running Sierra Chart
- HTTP server bound to `0.0.0.0` for LAN access
- .scid files are binary tick data, typically ~67MB per instrument
- HTTP Range requests enable incremental fetch — only download new ticks since last fetch
- Windows Firewall must be temporarily disabled for the fetch (Start/Stop shortcuts on Desktop)
- Sierra Start/Stop shortcuts on Windows Desktop for quick firewall toggle

### Version History (Condensed)

| Version | Primary Fix |
|---|---|
| v1-v3 | Basic signal logic, UTC date bugs, entry bar issues |
| v4-v6 | Trail stop moved to bar-close, drawing cleanup, alert dedup |
| v7-v9 | Persistent variable init, subgraph sizing, multi-TF alignment |
| v10-v11 | Float precision, input ordering stability, DLL reload handling |

## Connections
- [[6e-trading-system]] — the DH_Scanner study is the live execution layer of the DH|S2 strategy described there
- [[trading-discipline-and-psychology]] — the patience to debug through 11 versions mirrors the patience required to wait for valid setups
- [[knowledge-compounding]] — each Sierra version compounds defensive knowledge; v11 contains the scar tissue of all previous failures

## Open Questions
- Should the 12 learnings be versioned independently from the study itself (so they can be applied to future non-DH studies)?
- Is there a way to automate the DLL hot-reload problem (file watcher that forces Sierra to re-add the study)?
- Can the trade-validator comparison be run in CI on every Python strategy change to catch drift automatically?
- Are there additional learnings hiding in v1-v11 git history that were not explicitly documented?
