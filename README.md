# dotfiles

Personal dotfiles managed with [dotbot](https://github.com/anishathalye/dotbot).

## Installation

```bash
git clone https://github.com/bleafman/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install
```

The install script is idempotent and can be run multiple times safely.

## What's included

### Shell configuration
- `zshrc` - Zsh configuration with sensible defaults
- `zprofile` - Login shell setup (Homebrew)
- `shell/` - Modular shell configs:
  - `aliases.sh` - Common aliases (ls, docker, navigation)
  - `functions.sh` - Utility functions (git shortcuts, directory bookmarks)
  - `claude.sh` - Claude Code helper (`claude-yolo` for toggling permissive mode)
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

- [Homebrew](https://brew.sh/)
- [zsh](https://www.zsh.org/) - `brew install zsh`
- [Starship](https://starship.rs/) - `brew install starship`
- [nvm](https://github.com/nvm-sh/nvm) (optional, for Node.js)

## Updating

Pull changes and re-run install:

```bash
cd ~/dotfiles
git pull
./install
```

Or use the `dfu` alias from anywhere.
