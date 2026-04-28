# Zsh options
setopt AUTO_CD              # cd by typing directory name
setopt AUTO_PUSHD           # Push directories onto stack
setopt PUSHD_IGNORE_DUPS    # No duplicates in dir stack
setopt HIST_IGNORE_ALL_DUPS # No duplicate history entries
setopt HIST_SAVE_NO_DUPS    # Don't save duplicates
setopt HIST_IGNORE_SPACE    # Don't save commands starting with space (handy for secrets)
setopt HIST_REDUCE_BLANKS   # Strip extra whitespace before saving
setopt INC_APPEND_HISTORY   # Append immediately, not on shell exit
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
source ~/.shell/docker.sh

# Functions
source ~/.shell/functions.sh

# Starship
export STARSHIP_CONFIG="$HOME/.shell/starship.toml"
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# fzf (Ctrl+R history, Ctrl+T file picker, Alt+C cd)
if command -v fzf &> /dev/null; then
    eval "$(fzf --zsh)"
fi

# zoxide (smarter cd: `z foo` jumps to most-frecent match)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
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

# fnm (Node version manager — Rust-based replacement for nvm)
if command -v fnm &> /dev/null; then
    eval "$(fnm env --use-on-cd)"
fi

# LM Studio CLI (macOS only)
if [[ -n "$IS_MACOS" && -d "$HOME/.lmstudio/bin" ]]; then
    export PATH="$PATH:$HOME/.lmstudio/bin"
fi
export PATH="$HOME/.local/bin:$PATH"
