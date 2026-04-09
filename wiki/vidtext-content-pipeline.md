---
title: VidText Content Pipeline
domains: [#content, #engineering, #ai]
created: 2026-04-10
updated: 2026-04-10
sources:
  - project_content_listener.md
  - feedback_no_paid_apis.md
  - user_sarthak.md
---

# VidText Content Pipeline

VidText (Content Listener) is a free, local-first tool that transcribes YouTube videos, Instagram reels, and Spotify podcasts, then summarizes and extracts actionables based on a user-provided objective. It runs as a Python FastAPI backend (port 8420), a CLI agent, and a Chrome extension (v1.1.0) with Capture, Batch, Status (live progress), and History tabs. Everything is designed to work at zero cost — local Whisper for transcription, local summarization when no API key is available, and SQLite for persistence.

## Key Insights
- Smart Whisper model selection: videos 10 minutes or shorter use the base model for accuracy; longer videos use the tiny model for speed
- YouTube 429 rate limiting is a real problem — when subtitle fetching is blocked, the system falls back to Whisper transcription automatically
- Instagram requires `--cookies-from-browser chrome` to authenticate downloads
- Kindle delivery works via Gmail SMTP through the kindle-agent — no paid email service needed
- `local_summarize` mode activates when no ANTHROPIC_API_KEY is set, keeping the tool fully functional offline
- SQLite stores all transcription results, summaries, and metadata — simple, portable, no server dependency
- The Chrome extension is the primary user interface, turning any browser tab into a transcription trigger

## Details

### Architecture

| Component | Location | Purpose |
|---|---|---|
| Agent orchestrator | `personal/content-listener/agent/content_agent.py` | CLI entry point, coordinates skills |
| Transcriber skill | `personal/content-listener/skill/transcriber.py` | Platform-specific download + Whisper |
| Summarizer skill | `personal/content-listener/skill/summarizer.py` | Objective-driven summarization |
| Actionable extractor | `personal/content-listener/skill/actionable_extractor.py` | Pulls next-steps from transcript |
| Kindle sender | `personal/content-listener/skill/kindle_sender.py` | Gmail SMTP to Kindle email |
| FastAPI server | `personal/content-listener/project/backend/server.py` | HTTP API for Chrome extension |
| Chrome extension | `personal/content-listener/project/chrome-extension/` | Browser UI (Capture/Batch/Status/History) |

### Running It

- **Server:** `python -m project.backend.server` (port 8420)
- **CLI:** `python -m agent.content_agent --urls URL --objective "..." --question "..."`
- **Chrome extension:** Load unpacked from `personal/content-listener/project/chrome-extension/`

### Platform Quirks

**YouTube:** The biggest pain point is 429 rate limiting. YouTube aggressively blocks subtitle API requests, especially from automated tools. The fallback chain is: try official subtitles API, then try yt-dlp subtitle extraction, then fall back to full audio download + Whisper transcription. The Whisper fallback always works but is slower.

**Instagram:** Requires browser cookies for authentication. The `--cookies-from-browser chrome` flag extracts cookies from the local Chrome profile. This breaks if Chrome updates its cookie encryption, requiring a re-auth cycle.

**Spotify:** Podcast episodes are downloaded as audio and transcribed via Whisper. No subtitle fallback exists for audio-only content.

### Zero-Cost Design

The entire stack is designed around the constraint of zero paid APIs:
- Whisper runs locally (no OpenAI API charges)
- Summarization uses local models when no API key is present
- SQLite replaces any cloud database
- Gmail SMTP for Kindle delivery (free with existing Gmail account)
- Chrome extension is self-hosted (load unpacked, no Chrome Web Store fees)

## Connections
- [[builder-content-strategy]] — VidText is a primary MAIN reel subject for Claude Paglu, demonstrating real AI building
- [[zero-cost-architecture]] — VidText is a textbook example of the zero-investment constraint applied to a real tool
- [[automation-as-lifestyle]] — The Chrome extension + batch processing turn content consumption into an automated pipeline
- [[the-goel-family-builder]] — Embodies the "do everything, leave no manual steps" philosophy

## Open Questions
- Can the YouTube 429 problem be solved with rotating proxy support, or is Whisper fallback good enough?
- Should VidText support video summarization (not just audio) using vision models for visual content?
- Is there a path to making the Chrome extension publicly available on the Web Store without incurring costs?
- Could transcript embeddings enable semantic search across all consumed content?
