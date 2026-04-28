# ls — prefer eza if installed, fall back to coreutils
if command -v eza &> /dev/null; then
    alias ls='eza --group-directories-first'
    alias ll='eza -lah --git --group-directories-first'
    alias la='eza -A --group-directories-first'
    alias lt='eza --tree --level=2'
elif [[ -n "$IS_MACOS" ]]; then
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

# Claude
alias c='claude'

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

# Better ls (overridden above when eza is available)
if ! command -v eza &> /dev/null; then
    alias ll='ls -lah'
    alias la='ls -A'
fi

# Utility
alias path='echo -e ${PATH//:/\\n}'
alias reload='source ~/.zshrc'