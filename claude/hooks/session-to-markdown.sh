#!/bin/bash
# Convert Claude Code session JSONL to searchable markdown
# Triggered by SessionEnd and PreCompact hooks

set -e

# Read hook input from stdin
INPUT=$(cat)

SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')
HOOK_EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // "unknown"')

# Validate inputs
if [ -z "$TRANSCRIPT_PATH" ] || [ ! -f "$TRANSCRIPT_PATH" ]; then
    echo "No transcript found at: $TRANSCRIPT_PATH" >&2
    exit 0  # Don't fail the hook, just skip
fi

if [ -z "$CWD" ]; then
    CWD="$HOME"
fi

# Centralized session archive, organized per project
# CLAUDE_PROJECT_DIR is provided by Claude Code to hooks
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$CWD}"
PROJECT_NAME=$(basename "$PROJECT_DIR" | sed 's/[^A-Za-z0-9._-]/_/g')
[ -z "$PROJECT_NAME" ] && PROJECT_NAME="root"
OUTPUT_DIR="$HOME/.claude/sessions/$PROJECT_NAME"
mkdir -p "$OUTPUT_DIR"

# Get first timestamp for filename
FIRST_TS=$(head -1 "$TRANSCRIPT_PATH" | jq -r '.timestamp // empty' | cut -d'T' -f1,2 | tr 'T' '_' | tr ':' '-' | cut -d'.' -f1)
if [ -z "$FIRST_TS" ]; then
    FIRST_TS=$(date -u +"%Y-%m-%d_%H-%M-%S")
fi

# Get first user message for filename slug
FIRST_MSG=$(jq -r 'select(.type == "user") | .message.content // empty' "$TRANSCRIPT_PATH" | head -1 | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | cut -c1-30 | sed 's/-*$//')
if [ -z "$FIRST_MSG" ]; then
    FIRST_MSG="session"
fi

OUTPUT_FILE="$OUTPUT_DIR/${FIRST_TS}Z-${FIRST_MSG}.md"

# If PreCompact, add suffix to distinguish from final
if [ "$HOOK_EVENT" = "PreCompact" ]; then
    OUTPUT_FILE="$OUTPUT_DIR/${FIRST_TS}Z-${FIRST_MSG}-precompact.md"
fi

# Convert JSONL to Markdown
{
    echo "<!-- Session $SESSION_ID -->"
    echo "<!-- Project: $PROJECT_DIR -->"
    echo ""
    echo "# ${FIRST_TS//_/ }"
    echo ""

    jq -r '
        def format_content:
            if type == "array" then
                map(
                    if .type == "text" then .text
                    elif .type == "tool_use" then "<tool>\(.name): \(.input | tostring | .[0:200])...</tool>"
                    elif .type == "tool_result" then "<tool-result>\(.content | tostring | .[0:500])...</tool-result>"
                    else .type
                    end
                ) | join("\n\n")
            elif type == "string" then .
            else tostring
            end;

        if .type == "user" then
            "_**User (\(.timestamp))**_\n\n\(.message.content | format_content)\n\n---\n"
        elif .type == "assistant" then
            "_**Assistant (\(.message.model // "claude") \(.timestamp))**_\n\n\(.message.content | format_content)\n\n---\n"
        else
            empty
        end
    ' "$TRANSCRIPT_PATH"

} > "$OUTPUT_FILE"

echo "Session saved to: $OUTPUT_FILE"
