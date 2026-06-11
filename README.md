# dotfiles

Personal configuration repository for zsh, Neovim, and terminal emulators.

## Quick Start

```bash
# Automated setup (one-liner)
curl -fsSL https://raw.githubusercontent.com/Akshaj-Bisht/dotfiles/main/install.sh | bash

# Or manual setup
git clone --bare https://github.com/Akshaj-Bisht/dotfiles.git ~/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dotfiles checkout
dotfiles config status.showUntrackedFiles no
```

## Included

- **Zsh** - Optimized shell with compinit caching (24h), FZF, Zoxide
- **Neovim 0.12.2** - LSP, Treesitter, completion with auto-install
- **Foot/Alacritty** - Terminal emulators with noctalia theme
- **Install script** - Auto-detects OS, installs packages, sets up everything

## Usage

```bash
# Manage dotfiles like git
dotfiles status
dotfiles add .config/nvim/init.lua
dotfiles commit -m "Update nvim"
dotfiles push

# Sync across machines
dotfiles pull
```

## First Time

After setup, open a file in Neovim to trigger auto-installation of LSP servers and Treesitter parsers.

## Supported Systems

- Arch Linux (and derivatives: Manjaro, CachyOS)
- Ubuntu/Debian
- macOS

## Troubleshooting

**`dotfiles` command not found:**
```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
```

**Slow zsh completion:**
```bash
rm ~/.cache/zsh/zcompdump*
exec zsh
```

**Nvim plugins not installing:**
```bash
nvim +Mason  # Check Mason UI
# Ensure: gcc --version, tree-sitter --version
```

**Conflicts on first checkout:**
```bash
mkdir -p ~/.config-backup
dotfiles checkout 2>&1 | grep "error:" | awk '{print $4}' | xargs -I {} mv {} ~/.config-backup/
dotfiles checkout
```

## Configs

```
~/.config/
├── zsh/           # Shell config (.zshrc, aliases, keybindings)
├── nvim/          # Neovim config (LSP, plugins, keymaps)
├── foot/          # Foot terminal
└── alacritty/     # Alacritty terminal
```

## Performance

- **Zsh startup:** ~50-100ms (optimized compinit)
- **Nvim startup:** ~100-200ms (lazy-loaded plugins)

---

Bare repo managed with: `git --git-dir=$HOME/.dotfiles --work-tree=$HOME`
