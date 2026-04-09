---
title: Builder Content Strategy
domains: [#content, #growth]
created: 2026-04-10
updated: 2026-04-10
sources:
  - project_claude_paglu.md
  - feedback_content_not_clickbait.md
  - user_sarthak.md
---

# Builder Content Strategy

Claude Paglu is a zero-face AI content brand for Instagram and YouTube Shorts, built on the philosophy "I BUILD with AI, not report on AI." Every reel showcases real projects Sarthak is building — VidText, the 6E trading monitor, IPL predictor — rather than recycling AI news. Filler reels covering tools and trends supplement the feed but never lead it. The entire editing pipeline runs on Remotion (React-based, 1080x1920, spring animations, word-by-word captions), and five Claude agents orchestrate the daily pipeline from topic selection to final edit spec.

## Key Insights
- MAIN reels must demonstrate real builds (VidText, trading monitor, IPL predictor) — this is the differentiator from every other AI page
- FILLER reels (AI news, tool reviews) supplement but never dominate — they keep the feed active on low-build days
- Hook styles analyzed from @manikk.ai (Hinglish "Bhai" hooks that feel like a friend talking) and @nateherkai (contrast hooks that set up expectation vs reality)
- CTA formula: "Day X of AI Paglu. Kal aur crazy dikhaunga — miss mat karna" — creates FOMO without begging for saves/shares
- Comment-for-PDF flywheel via ManyChat (free) — drives engagement and builds email list simultaneously
- Target audience: people who want to know about AI, want to start using AI, or have FOMO about AI
- Content must add value, not just entertain — the builder angle IS the value

## Details

### The 5-Agent Pipeline

| Agent | Responsibility |
|---|---|
| paglu-manager | Orchestrates daily pipeline: topic selection, script, storyboard, output packaging |
| content-decoder | Analyzes competitor/influencer reels — extracts hook patterns, script structure, pacing, retention curves |
| scriptwriter | Writes 60-second Hinglish scripts with hook, core explanation, twist, CTA — follows the builder-not-reporter rule |
| visual-director | Creates shot-by-shot storyboard with infographic specs, motion design notes, and timing |
| trend-scanner | Scans AI news for trending topics worth covering as filler reels |

### Remotion Editing Pipeline

The entire video pipeline is code-driven using Remotion:
- React components render each scene at 1080x1920 (vertical)
- Spring animations for transitions and element entrances
- Word-by-word captions synced to voiceover timing
- Infographics rendered as SVG components with animated data reveals
- All templates version-controlled — a new reel is mostly data, not design

### Content Hierarchy

1. **MAIN reels** (3-4/week): Real project demos — screen recordings, architecture walkthroughs, "I built this in X hours" narratives
2. **FILLER reels** (2-3/week): AI news, tool comparisons, quick tips — keeps algorithm fed
3. **SERIES reels**: "Day X of AI Paglu" numbering creates continuity and commitment

### Growth Target

100K followers in 30 days — aggressive but achievable if the builder content resonates with the AI-curious audience in India. The Hinglish angle narrows competition significantly compared to English-only AI pages.

## Connections
- [[vidtext-content-pipeline]] — VidText is a primary MAIN reel subject, showcasing the transcription tool being built
- [[automation-as-lifestyle]] — The Remotion pipeline and 5-agent system are themselves examples of the automation-first mindset
- [[the-goel-family-builder]] — The "builder over reporter" philosophy ties directly to Sarthak's identity

## Open Questions
- What's the optimal MAIN:FILLER ratio for early growth vs established audience?
- Should Remotion templates be open-sourced as a growth hack (comment-for-template)?
- How to measure whether builder content actually converts better than news content — A/B test framework needed?
- Is 60 seconds the right length or should some MAIN reels go 90s for complex builds?
