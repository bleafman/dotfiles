# Zsh options
setopt AUTO_CD              # cd by typing directory name
setopt AUTO_PUSHD           # Push directories onto stack
setopt PUSHD_IGNORE_DUPS    # No duplicates in dir stack
setopt HIST_IGNORE_ALL_DUPS # No duplicate history entries
setopt HIST_SAVE_NO_DUPS    # Don't save duplicates
setopt SHARE_HISTORY        # Share history across sessions
setopt EXTENDED_GLOB        # Extended globbing patterns

# History config
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# Completion system
autoload -Uz compinit
compinit -C  # -C skips security check for faster startup

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ENV Variables
source ~/.shell/env.sh
[[ -f ~/.shell/env.local.sh ]] && source ~/.shell/env.local.sh

# Aliases
source ~/.shell/aliases.sh
source ~/.shell/fluint.sh
source ~/.shell/claude.sh

# Functions
source ~/.shell/functions.sh

# Starship
export STARSHIP_CONFIG="$HOME/.shell/starship.toml"
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# pnpm
if [[ -n "$IS_MACOS" ]]; then
    export PNPM_HOME="$HOME/Library/pnpm"
else
    export PNPM_HOME="$HOME/.local/share/pnpm"
fi
[[ -d "$PNPM_HOME" ]] && export PATH="$PNPM_HOME:$PATH"

# Warp terminal (macOS only)
if [[ -n "$IS_MACOS" && "$TERM_PROGRAM" == "WarpTerminal" ]]; then
    printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh" }}\x9c'
fi

# NVM
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"

# Local binaries (dcg, etc.)
export PATH="$HOME/.local/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# dcg: warn if hook was silently removed from Claude Code settings
if command -v dcg &>/dev/null && command -v jq &>/dev/null; then
    if [ -f "$HOME/.claude/settings.json" ] && \
       ! jq -e '.hooks.PreToolUse[]? | select(.hooks[]?.command | test("dcg$"))' \
         "$HOME/.claude/settings.json" &>/dev/null; then
        printf '\033[1;33m[dcg] Hook missing from ~/.claude/settings.json — run: dcg install\033[0m\n'
    fi
fi
