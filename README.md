# dotfiles

Personal dotfiles managed with [dotbot](https://github.com/anishathalye/dotbot).

## Installation

```bash
git clone https://github.com/bleafman/dotfiles.git ~/dotfiles
cd ~/dotfiles
brew bundle    # install all CLI tools (see Brewfile)
./install      # symlink dotfiles
```

The install script is idempotent and can be run multiple times safely.

### Work-specific layers

Some tools are only needed on specific machines. Each context has a bootstrap
script under `bundles/` that's layered on top of the base setup.

```bash
./bundles/antithesis.sh   # Antithesis work machine extras
```

These scripts handle anything that doesn't fit cleanly in a Brewfile (npm
globals, manual installs, etc.) and are idempotent.

## What's included

### Shell configuration
- `zshrc` - Zsh configuration with sensible defaults
- `zprofile` - Login shell setup (Homebrew)
- `shell/` - Modular shell configs:
  - `aliases.sh` - Common aliases (ls, docker, navigation)
  - `functions.sh` - Utility functions (git shortcuts, directory bookmarks)
  - `docker.sh` - Docker compose helpers (`dl`, `dcr`)
  - `starship.toml` - Starship prompt configuration

### Git
- `.gitconfig` - Git aliases and settings
- `gitignore_global` - Global gitignore patterns

## Symlinks created

| Source | Destination |
|--------|-------------|
| `zshrc` | `~/.zshrc` |
| `zprofile` | `~/.zprofile` |
| `.gitconfig` | `~/.gitconfig` |
| `gitignore_global` | `~/.gitignore_global` |
| `shell/` | `~/.shell/` |

## Prerequisites

- [Homebrew](https://brew.sh/) — everything else is in the `Brewfile`

The Brewfile installs:
- **starship** — prompt
- **fnm** — Node version manager (replaces nvm; faster startup)
- **fzf** — fuzzy finder (Ctrl+R for history, Ctrl+T for files, Alt+C for cd)
- **zoxide** — smarter `cd` (`z foo` jumps to most-frecent match)
- **eza** — modern `ls` (used by `ls`/`ll`/`la`/`lt` aliases when present)
- **bat** — `cat` with syntax highlighting
- **gh** — GitHub CLI

## Updating

Pull changes and re-run install:

```bash
cd ~/dotfiles
git pull
./install
```

Or use the `dfu` alias from anywhere.
