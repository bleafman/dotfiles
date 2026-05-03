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

# Note: `uv run` is allowed freely. Other rules in this file (rm -rf,
# sf destructive ops, etc.) check the full command string regardless
# of how it was invoked, so `uv run rm -rf /` is still blocked by
# the rm rule below.

# Ask confirmation for force push to main/master
if echo "$COMMAND" | grep -qE 'git\s+push\s+.*--force.*\s+(main|master)|git\s+push\s+.*\s+(main|master)\s+.*--force|git\s+push\s+-f.*\s+(main|master)'; then
    cat << 'EOF'
{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "ask", "permissionDecisionReason": "Force push to main/master detected. Consider `--force-with-lease` instead (safer - fails if remote has unseen changes)."}}
EOF
    exit 0
fi

# ---------------- Salesforce CLI destructive operations ----------------
# Hard deny — if you genuinely need these, run them yourself in your shell.
# Covers both new sf and legacy sfdx force:* syntaxes. Matches command
# boundaries to reduce false positives in commit messages / heredocs.

# Block: anonymous Apex execution (can do literally anything to org)
if echo "$COMMAND" | grep -qE '(^|[;&|]\s*)(sf\s+apex\s+run|sfdx\s+force:apex:execute)\b'; then
    cat << 'EOF'
{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": "Salesforce apex execution blocked: anonymous apex can destroy any data in the org. Run manually if intended."}}
EOF
    exit 0
fi

# Block: data delete (record / bulk / resume / etc.)
if echo "$COMMAND" | grep -qE '(^|[;&|]\s*)(sf\s+data\s+delete|sfdx\s+force:data:[a-z]+:delete)\b'; then
    cat << 'EOF'
{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": "Salesforce data delete blocked: deletions via CLI are not undoable. Run manually if intended."}}
EOF
    exit 0
fi

# Block: data update / upsert (mass writes can be destructive)
if echo "$COMMAND" | grep -qE '(^|[;&|]\s*)(sf\s+data\s+(update|upsert)|sfdx\s+force:data:[a-z]+:(update|upsert))\b'; then
    cat << 'EOF'
{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": "Salesforce data update/upsert blocked: mass writes can be destructive. Run manually if intended."}}
EOF
    exit 0
fi

# Block: org deletion (scratch / sandbox / etc.)
if echo "$COMMAND" | grep -qE '(^|[;&|]\s*)(sf\s+org\s+delete|sfdx\s+force:org:delete)\b'; then
    cat << 'EOF'
{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": "Salesforce org delete blocked: irreversible. Run manually if intended."}}
EOF
    exit 0
fi

# Block: destructive metadata deployments
if echo "$COMMAND" | grep -qE 'sf\s+project\s+deploy\b.*--(pre-|post-)?destructive-changes\b'; then
    cat << 'EOF'
{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": "Salesforce destructive deployment blocked: --destructive-changes / --pre-destructive-changes / --post-destructive-changes deletes metadata. Run manually if intended."}}
EOF
    exit 0
fi

# Allow everything else
exit 0
