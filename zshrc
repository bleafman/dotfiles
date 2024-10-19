# Aliases
source ~/.shell/aliases.sh

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
