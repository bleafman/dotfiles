#!/bin/bash
# Command validator hook for Claude Code
# Blocks dangerous commands before execution

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)

# Only check Bash commands
[ "$TOOL_NAME" != "Bash" ] && exit 0

COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

# Block rm -rf and rm -r (use trash instead)
if echo "$COMMAND" | grep -qE '\brm\s+(-[a-zA-Z]*r[a-zA-Z]*\s+|.*-rf|-fr)'; then
    cat << 'EOF'
{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": "rm -rf/rm -r blocked. Use `trash` instead."}}
EOF
    exit 0
fi

# Block uv run unless it's strictly `uv run <file>.py [args]` (no flags before the script)
# Blocks: uv run python, uv run bash, uv run --with pkg script.py, etc.
# Only matches `uv run` as a command (start of line or after && ; |), not as part of filenames
if echo "$COMMAND" | grep -qE '(^|[;&|]\s*)uv\s+run\b'; then
    if ! echo "$COMMAND" | grep -qE '(^|[;&|]\s*)uv\s+run\s+[A-Za-z0-9_./-]+\.py\b'; then
        cat << 'EOF'
{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": "uv run blocked: only `uv run <script>.py [args]` is allowed. No flags, no arbitrary commands."}}
EOF
        exit 0
    fi
fi

# Ask confirmation for force push to main/master
if echo "$COMMAND" | grep -qE 'git\s+push\s+.*--force.*\s+(main|master)|git\s+push\s+.*\s+(main|master)\s+.*--force|git\s+push\s+-f.*\s+(main|master)'; then
    cat << 'EOF'
{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "ask", "permissionDecisionReason": "Force push to main/master detected. Consider `--force-with-lease` instead (safer - fails if remote has unseen changes)."}}
EOF
    exit 0
fi

# Allow everything else
exit 0
