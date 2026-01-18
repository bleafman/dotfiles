# Zsh options
setopt AUTO_CD              # cd by typing directory name
setopt AUTO_PUSHD           # Push directories onto stack
setopt PUSHD_IGNORE_DUPS    # No duplicates in dir stack
setopt HIST_IGNORE_ALL_DUPS # No duplicate history entries
setopt HIST_SAVE_NO_DUPS    # Don't save duplicates
setopt SHARE_HISTORY        # Share history across sessions
setopt EXTENDED_GLOB        # Extended globbing patterns

# Completion system
autoload -Uz compinit
compinit -C  # -C skips security check for faster startup

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ENV Variables
source ~/.shell/env.sh

# Aliases
source ~/.shell/aliases.sh
source ~/.shell/fluint.sh
source ~/.shell/claude.sh

# Functions
source ~/.shell/functions.sh

# Starship
export STARSHIP_CONFIG="$HOME/.dotfiles/shell/starship.toml"
eval "$(starship init zsh)"

# pnpm
export PNPM_HOME="/Users/brandon.leafman/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# Warpify Subshells
printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh" }}\x9c'

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/brandon/.lmstudio/bin"
export PNPM_HOME="/Users/brandon/Library/pnpm"
