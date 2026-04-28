#!/usr/bin/env bash
# Bootstrap script for Antithesis work machines.
# Layered ON TOP of the personal/general dev setup (Brewfile + ./install).
#
# Usage from a fresh ~/dotfiles:
#   brew bundle           # personal/common tools
#   ./install             # symlink dotfiles
#   ./bundles/antithesis.sh   # work-specific layer

set -euo pipefail

echo "→ Antithesis bootstrap"

# ---- Brew formulae / casks (work-specific) ----
# Add any here if needed in future. Currently none.
# brew install <formula>

# ---- npm globals ----
if ! command -v npm &> /dev/null; then
    echo "  npm not found — install Node via fnm first (e.g., fnm install --lts)"
    exit 1
fi

ensure_npm_global() {
    local pkg="$1"
    local bin="$2"
    if command -v "$bin" &> /dev/null; then
        echo "  ✓ $bin already installed"
    else
        echo "  → installing $pkg"
        npm install -g "$pkg"
    fi
}

# Salesforce CLI — brew formula is deprecated (Gatekeeper), npm is the
# recommended install path per Salesforce.
ensure_npm_global "@salesforce/cli" "sf"

echo "✓ Antithesis bootstrap complete"
