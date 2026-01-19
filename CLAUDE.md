# Claude Code Instructions

This is a personal dotfiles repository using [dotbot](https://github.com/anishathalye/dotbot) for symlink management.

## Structure

- `install` - Dotbot bootstrap script (run this to apply dotfiles)
- `install.conf.yaml` - Dotbot configuration defining symlinks
- `shell/` - Modular shell configuration files sourced by zshrc
- `.claude/` - Claude Code project settings

## Making changes

- Run `./install` after modifying `install.conf.yaml` to apply symlink changes
- Shell config changes in `shell/` take effect on new shells or after `source ~/.zshrc`
- The install script is idempotent - safe to run repeatedly

## Cross-platform support

The dotfiles detect the OS via `uname` and set `IS_MACOS` or `IS_LINUX` in `shell/env.sh`. Platform-specific config (Homebrew paths, pnpm, Warp, LM Studio) is conditionally loaded.

Homebrew paths are auto-detected in `zprofile`:
- macOS Apple Silicon: `/opt/homebrew/bin/brew`
- macOS Intel: `/usr/local/bin/brew`
- Linux: `/home/linuxbrew/.linuxbrew/bin/brew`
