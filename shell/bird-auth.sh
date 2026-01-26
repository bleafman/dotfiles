#!/bin/bash
# bird-auth: Extract Twitter cookies from Chrome/Safari and write to bird config
# auth_token is httpOnly so must be set manually once (lasts months)
# ct0 can be refreshed automatically via JavaScript

set -e

CONFIG_DIR="$HOME/.config/bird"
CONFIG_FILE="$CONFIG_DIR/config.json5"

mkdir -p "$CONFIG_DIR"

# Check for existing auth_token
EXISTING_AUTH=""
if [[ -f "$CONFIG_FILE" ]]; then
    EXISTING_AUTH=$(grep -o 'authToken: *"[^"]*"' "$CONFIG_FILE" 2>/dev/null | cut -d'"' -f2 || true)
fi

# Get ct0 from browser
if pgrep -x "Google Chrome" > /dev/null; then
    BROWSER="Chrome"
    COOKIES=$(osascript -e 'tell application "Google Chrome" to execute front window'\''s active tab javascript "document.cookie"' 2>&1)
elif pgrep -x "Safari" > /dev/null; then
    BROWSER="Safari"
    COOKIES=$(osascript -e 'tell application "Safari" to do JavaScript "document.cookie" in document 1' 2>&1)
else
    echo "Error: Neither Chrome nor Safari is running."
    echo "Open a browser and navigate to x.com first."
    exit 1
fi

CT0=$(echo "$COOKIES" | tr ';' '\n' | grep -o 'ct0=[^;]*' | cut -d'=' -f2 | tr -d ' ')

if [[ -z "$CT0" ]]; then
    echo "Error: ct0 not found. Make sure x.com is the active tab and you're logged in."
    exit 1
fi

# If no existing auth_token, prompt for it
if [[ -z "$EXISTING_AUTH" ]]; then
    echo "No auth_token found in config."
    echo ""
    echo "To get it (one-time setup):"
    echo "  1. Open x.com in Chrome/Safari"
    echo "  2. Press F12 (or Cmd+Option+I) for DevTools"
    echo "  3. Go to Application tab → Cookies → https://x.com"
    echo "  4. Find 'auth_token' and copy the value"
    echo ""
    read -p "Paste auth_token here: " EXISTING_AUTH

    if [[ -z "$EXISTING_AUTH" ]]; then
        echo "Error: auth_token is required."
        exit 1
    fi
    echo ""
fi

# Write config
cat > "$CONFIG_FILE" << EOF
{
  // auth_token: set manually, lasts months
  // ct0: auto-refreshed from browser
  authToken: "$EXISTING_AUTH",
  ct0: "$CT0"
}
EOF

echo "Updated $CONFIG_FILE"
echo "  auth_token: ${EXISTING_AUTH:0:10}..."
echo "  ct0: ${CT0:0:20}..."
echo ""
echo "Testing with 'bird whoami'..."
bird whoami
