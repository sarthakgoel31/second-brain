#!/bin/bash
# Daily Brain Feed — extracts key insights from today's Claude sessions
# and saves them as raw notes for the second brain.
# Run via cron or launchd at end of day (e.g., 11:30 PM IST)

set -euo pipefail

BRAIN_DIR="$HOME/Claude/personal/second-brain"
RAW_NOTES="$BRAIN_DIR/raw/notes"
TODAY=$(date +%Y-%m-%d)
SESSION_DIR="$HOME/.claude/projects/-Users-sarthak-Claude"

# Check if today's note already exists
if [ -f "$RAW_NOTES/$TODAY-session-insights.md" ]; then
    echo "Today's insights already captured. Skipping."
    exit 0
fi

# Find today's session files (JSONL logs)
SESSION_FILES=$(find "$SESSION_DIR" -name "*.jsonl" -newer "$RAW_NOTES/.gitkeep" -mtime 0 2>/dev/null || true)

if [ -z "$SESSION_FILES" ]; then
    echo "No session files from today. Nothing to capture."
    exit 0
fi

# Extract assistant messages from today's sessions (last 50 messages per file)
{
    echo "---"
    echo "added: $TODAY"
    echo "source: claude-sessions"
    echo "type: daily-session-extract"
    echo "---"
    echo ""
    echo "# Session Insights — $TODAY"
    echo ""
    echo "Auto-extracted from Claude Code sessions. Run \`/brain ingest\` to compile into wiki articles."
    echo ""

    for f in $SESSION_FILES; do
        echo "## $(basename "$f" .jsonl)"
        echo ""
        # Extract key decisions, learnings, and outcomes from assistant messages
        tail -100 "$f" 2>/dev/null | python3 -c "
import sys, json
for line in sys.stdin:
    try:
        msg = json.loads(line.strip())
        if msg.get('role') == 'assistant' and isinstance(msg.get('content'), str):
            text = msg['content']
            # Only capture substantive messages (>100 chars, not just tool calls)
            if len(text) > 100:
                # Truncate very long messages
                if len(text) > 500:
                    text = text[:500] + '...'
                print(f'- {text}')
                print()
    except (json.JSONDecodeError, KeyError):
        pass
" 2>/dev/null || echo "- (could not parse session)"
        echo ""
    done
} > "$RAW_NOTES/$TODAY-session-insights.md"

echo "Saved: $RAW_NOTES/$TODAY-session-insights.md"
echo "Run '/brain ingest' to compile into wiki articles."
