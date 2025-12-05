# Claude Code YOLO mode - temporarily enable permissive settings
# Settings update dynamically, so changes apply to running sessions immediately
# Works in any directory with a .claude folder (searches up the tree)
claude-yolo() {
    # Find .claude directory by walking up from current directory
    local dir="$(pwd)"
    local claude_dir=""
    local project_root=""
    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.claude" ]]; then
            claude_dir="$dir/.claude"
            project_root="$dir"
            break
        fi
        dir="$(dirname "$dir")"
    done

    if [[ -z "$claude_dir" ]]; then
        echo "❌ No .claude directory found in current path"
        return 1
    fi

    local CLAUDE_LOCAL_SETTINGS="$claude_dir/settings.local.json"
    local CLAUDE_STASHED_SETTINGS="$claude_dir/settings.local.stashed.json"

    case "$1" in
        enable)
            if [[ -f "$CLAUDE_STASHED_SETTINGS" ]]; then
                echo "⚠️  YOLO mode already enabled (stashed settings exist)"
                echo "   Run 'claude-yolo disable' first if you want to re-enable"
                return 1
            fi
            if [[ -f "$CLAUDE_LOCAL_SETTINGS" ]]; then
                cp "$CLAUDE_LOCAL_SETTINGS" "$CLAUDE_STASHED_SETTINGS"
                echo "Stashed current settings from $claude_dir"
            else
                # No local settings exist - create empty stash as marker
                echo "{}" > "$CLAUDE_STASHED_SETTINGS"
                echo "No existing local settings - created empty stash"
            fi
            cat > "$CLAUDE_LOCAL_SETTINGS" << 'EOF'
{
  "allow": [
    "Bash(*)",
    "Edit(*)",
    "Write(*)",
    "mcp__*"
  ]
}
EOF
            echo "🔓 YOLO mode enabled in $claude_dir"
            ;;
        disable)
            if [[ -f "$CLAUDE_STASHED_SETTINGS" ]]; then
                # Check if stash is the empty marker
                if [[ "$(cat "$CLAUDE_STASHED_SETTINGS")" == "{}" ]]; then
                    rm -f "$CLAUDE_LOCAL_SETTINGS" "$CLAUDE_STASHED_SETTINGS"
                    echo "🔒 YOLO mode disabled - removed local settings (none existed before)"
                else
                    mv "$CLAUDE_STASHED_SETTINGS" "$CLAUDE_LOCAL_SETTINGS"
                    echo "🔒 YOLO mode disabled - restored previous settings"
                fi
            else
                echo "⚠️  YOLO mode not enabled (no stashed settings found)"
                return 1
            fi
            ;;
        status)
            echo "📁 Claude directory: $claude_dir"
            if [[ -f "$CLAUDE_STASHED_SETTINGS" ]]; then
                echo "🔓 YOLO mode is ENABLED"
            else
                echo "🔒 YOLO mode is DISABLED"
            fi
            ;;
        *)
            echo "Usage: claude-yolo [enable|disable|status]"
            ;;
    esac
}
