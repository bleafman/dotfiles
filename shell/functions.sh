function g() {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    git status
  fi
}

here() {
    local loc
    if [ "$#" -eq 1 ]; then
        loc=$(realpath "$1")
    else
        loc=$(realpath ".")
    fi
    ln -sfn "${loc}" "$HOME/.shell.here"
    echo "here -> $(readlink $HOME/.shell.here)"
}

# Directory bookmarks
export MARKPATH=$HOME/.marks
jump() {
  cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
mark() {
  mkdir -p "$MARKPATH"
  ln -sf "$(pwd)" "$MARKPATH/${1:-$(basename $(pwd))}"
}
unmark() {
  rm -i "$MARKPATH/$1"
}
marks() {
  \ls -l "$MARKPATH" 2>/dev/null | awk 'NR>1 {print $9, "->", $11}' | column -t
}
alias j='jump'