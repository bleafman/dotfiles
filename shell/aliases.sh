# Use colors in coreutils utilities output
if [[ -n "$IS_MACOS" ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi
alias grep='grep --color'

# Aliases to protect against overwriting
alias cp='cp -i'
alias mv='mv -i'

# Python aliases
alias py='python'
alias py3='python3'

# Claude (function to ensure nvm is loaded first)
unalias c 2>/dev/null
function c {
    if [[ -s "$NVM_DIR/nvm.sh" ]] && ! command -v node &>/dev/null; then
        \. "$NVM_DIR/nvm.sh"
    fi
    claude "$@"
}

# Node aliases
alias nvmi='nvm use && npm install'

# Docker
alias dc='docker compose'
alias dcd='docker compose down'
alias dcu='docker compose up'
alias dcud='docker compose up -d'

# Update dotfiles
dfu() {
    (
        cd ~/dotfiles && git pull --ff-only && ./install -q
    )
}

# Go up [n] directories
up()
{
    local cdir="$(pwd)"
    if [[ "${1}" == "" ]]; then
        cdir="$(dirname "${cdir}")"
    elif ! [[ "${1}" =~ ^[0-9]+$ ]]; then
        echo "Error: argument must be a number"
    elif ! [[ "${1}" -gt "0" ]]; then
        echo "Error: argument must be positive"
    else
        for ((i=0; i<${1}; i++)); do
            local ncdir="$(dirname "${cdir}")"
            if [[ "${cdir}" == "${ncdir}" ]]; then
                break
            else
                cdir="${ncdir}"
            fi
        done
    fi
    cd "${cdir}"
}

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Better ls
alias ll='ls -lah'
alias la='ls -A'

# Utility
alias path='echo -e ${PATH//:/\\n}'
alias reload='source ~/.zshrc'