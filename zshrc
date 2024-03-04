# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# Aliases
source ~/.shell/aliases.sh

# Functions
source ~/.shell/functions.sh

# Built
source ~/.shell/built.sh

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Starship
export STARSHIP_CONFIG="$HOME/.dotfiles/shell/starship.toml"
eval "$(starship init zsh)"

# pnpm
export PNPM_HOME="/Users/brandon.leafman/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# Warpify Subshells
printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh" }}\x9c'

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
