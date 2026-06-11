# 🔧 Dotfiles

This repository contains optimized configuration files for zsh, Neovim, and other tools. It uses a bare git repository for seamless dotfiles management.

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [Installation](#installation)
- [Setup](#setup)
- [Usage](#usage)
- [Included Configs](#included-configs)
- [Performance Optimizations](#performance-optimizations)
- [Troubleshooting](#troubleshooting)

---

## 🚀 Quick Start

If you already have git installed, you can set up these dotfiles in minutes:

```bash
# Clone the bare repository
git clone --bare https://github.com/Akshaj-Bisht/dotfiles.git ~/.dotfiles

# Create the dotfiles alias in your current shell
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# Checkout the files into your home directory
dotfiles checkout

# Hide untracked files in dotfiles status (optional but recommended)
dotfiles config status.showUntrackedFiles no
```

---

## 📥 Installation

### Prerequisites

- **Linux system** (tested on Arch Linux)
- **Git** (for cloning and managing dotfiles)
- **zsh** (v5.9+)
- **Neovim** (v0.12.2+)

### Step 1: Clone the Repository

```bash
git clone --bare https://github.com/Akshaj-Bisht/dotfiles.git ~/.dotfiles
```

### Step 2: Create Alias (Choose One)

**Option A: Temporary (current shell only)**
```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
```

**Option B: Permanent (added to zsh)**
The alias is already configured in `.config/zsh/aliases.zsh`:
```zsh
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
```

### Step 3: Checkout Files

```bash
dotfiles checkout
```

If you get a conflict message, backup and remove conflicting files:
```bash
mkdir -p ~/.config-backup
dotfiles checkout 2>&1 | grep "error:" | awk '{print $4}' | xargs -I {} mv {} ~/.config-backup/
dotfiles checkout
```

### Step 4: Configure Git

```bash
# Hide untracked files (so dotfiles status only shows tracked files)
dotfiles config status.showUntrackedFiles no

# Set commit author if not already set
dotfiles config user.name "Your Name"
dotfiles config user.email "your.email@example.com"
```

---

## ⚙️ Setup

### 1. Zsh Configuration

After checkout, zsh will automatically load optimized configurations from `~/.config/zsh/`:

```bash
# Make zsh your default shell
chsh -s /bin/zsh

# Reload zsh
exec zsh
```

**What's configured:**
- ✅ History management (100k entries, persistent)
- ✅ Smart completion with `compinit` optimization (loads fast)
- ✅ Zoxide for directory navigation
- ✅ FZF fuzzy finder integration
- ✅ Useful aliases for common commands
- ✅ Git aliases for common operations

### 2. Neovim Configuration

Neovim 0.12.2+ uses a modern configuration structure in `~/.config/nvim/`:

```bash
# Install Neovim (if not present)
# For Arch Linux:
sudo pacman -S neovim

# For other distros, see: https://github.com/neovim/neovim/wiki/Installing-Neovim
```

**First time setup:**
1. Open any file: `nvim somefile.py`
2. Neovim will auto-install:
   - Treesitter parsers for syntax highlighting
   - LSP servers via Mason
   - Formatter tools (prettier, stylua, etc.)
3. Wait for installations to complete (watch for notifications)
4. Restart nvim when prompted

**What's pre-configured:**
- ✅ LSP support (Python, Go, Rust, JavaScript, TypeScript, C/C++, Lua, and more)
- ✅ Modern `blink.cmp` completion engine
- ✅ Treesitter syntax highlighting
- ✅ File explorer (oil.nvim)
- ✅ Git integration (gitsigns, lazygit, codediff)
- ✅ Debugging (DAP, DAP-UI)
- ✅ Formatters (conform.nvim, auto-format on save)
- ✅ Keymap discovery (which-key.nvim)

### 3. Other Tools

```bash
# FZF (fuzzy finder) - install system package
sudo pacman -S fzf  # Arch Linux
# or brew install fzf  # macOS

# Zoxide (smart directory navigation) - install system package
sudo pacman -S zoxide  # Arch Linux
# or brew install zoxide  # macOS

# Ripgrep (fast text search)
sudo pacman -S ripgrep  # Arch Linux

# EZA (ls replacement)
sudo pacman -S eza  # Arch Linux
```

---

## 💻 Usage

### Managing Dotfiles

Once set up, use the `dotfiles` alias just like regular git:

```bash
# Check status
dotfiles status

# View changes
dotfiles diff

# Add files to track
dotfiles add .config/nvim/init.lua

# Commit changes
dotfiles commit -m "Update nvim config"

# Push to remote
dotfiles push

# Pull from remote
dotfiles pull

# View commit history
dotfiles log --oneline -10

# See all dotfiles commands
dotfiles --help
```

### Common Workflows

**Update a config file and push:**
```bash
# Edit your file (e.g., nvim config)
nvim ~/.config/nvim/init.lua

# Check what changed
dotfiles diff

# Stage and commit
dotfiles add .config/nvim/init.lua
dotfiles commit -m "Update nvim: add new keybinding"

# Push to GitHub
dotfiles push
```

**Pull latest configs on another machine:**
```bash
# After initial setup:
dotfiles pull

# Or merge if you have local changes:
dotfiles pull --rebase
```

**Add a new config file:**
```bash
# Edit and save your config
nvim ~/.config/myapp/config.toml

# Add it to dotfiles
dotfiles add .config/myapp/config.toml

# Commit
dotfiles commit -m "Add myapp config"

# Push
dotfiles push
```

---

## 📂 Included Configs

### Zsh (`~/.config/zsh/`)
- `.zshrc` - Main zsh configuration
- `.zshenv` - Environment variables (XDG_CONFIG_HOME, ZDOTDIR)
- `aliases.zsh` - Command aliases
- `bindings.zsh` - Keybindings
- `fzf.zsh` - FZF integration
- `prompt.zsh` - Prompt configuration
- `plugins.zsh` - Plugin management

**Key features:**
- Optimized `compinit` - only runs full completion scan once per 24 hours
- Auto-completion for all installed commands
- Persistent history (100k entries)
- Case-insensitive, smart search

### Neovim (`~/.config/nvim/`)

**Core:**
- `init.lua` - Entry point, plugin loading, lazy-loading setup
- `lua/config/options.lua` - Vim options and settings
- `lua/config/keymaps.lua` - Key mappings
- `lua/config/autocmds.lua` - Autocommands

**Plugins:**
- `lua/plugins/lsp.lua` - LSP configuration with auto-install
- `lua/plugins/completion.lua` - Blink.cmp completion engine
- `lua/plugins/treesitter.lua` - Syntax highlighting
- `lua/plugins/ui.lua` - Theme, statusline, bufferline, alpha
- `lua/plugins/whichkey.lua` - Keymap discovery
- `lua/plugins/git.lua` - Git integration
- `lua/plugins/debug.lua` - Debugging (DAP)
- `lua/plugins/utils.lua` - Miscellaneous utilities
- `lua/plugins/oil.lua` - File explorer
- `lua/plugins/projects.lua` - Project management
- `lua/plugins/terminal.lua` - Terminal integration

**Optimizations:**
- ✅ Lazy-loaded plugins (load only when needed)
- ✅ Deferred LSP/Treesitter setup (not on startup)
- ✅ Incremental Treesitter parsing
- ✅ LSP logging disabled
- ✅ Smart startup screen loading
- ✅ Document highlight disabled (saves CPU)

---

## ⚡ Performance Optimizations

### Zsh Startup (Optimized)
**Before:** ~300-400ms  
**After:** ~50-100ms

**Key optimization:**
- `compinit` caching: completion scan only runs once per 24 hours instead of every startup

### Neovim Startup (Optimized)
**Before:** ~500-700ms  
**After:** ~100-200ms

**Key optimizations:**
1. **Plugin lazy-loading**: Heavy plugins load only on first use
2. **Deferred LSP**: LSP loads on first FileType event
3. **Deferred Treesitter**: Syntax highlighting loads per buffer
4. **Deferred completion**: Completion engine loads on InsertEnter
5. **Incremental Treesitter parsing**: Faster highlighting updates on large files
6. **Smart UI loading**: Startup screen & bufferline only load when needed

---

## 🔧 Troubleshooting

### Issue: `dotfiles` command not found

**Solution:** Add the alias to your current shell:
```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
```

Or source your zsh config:
```bash
source ~/.config/zsh/.zshrc
```

### Issue: Zsh completion is slow

**Solution:** The `compinit` cache is outdated. Force refresh:
```bash
rm ~/.cache/zsh/zcompdump*
# Restart zsh
exec zsh
```

### Issue: Neovim plugins not installing

**Solution:** Check Mason status:
```bash
nvim +Mason
```

If LSP servers won't install:
1. Ensure you have a C compiler: `gcc --version`
2. Ensure tree-sitter CLI is installed: `tree-sitter --version`
3. Check network connectivity

### Issue: Git says "fatal: your current branch differs"

**Solution:** This is normal on first checkout. Just stash changes:
```bash
cd ~
dotfiles stash
dotfiles checkout
```

### Issue: Some configs not syncing

**Solution:** Check what's being tracked:
```bash
dotfiles ls-files
```

To add more configs:
```bash
dotfiles add .config/your-app/config
dotfiles commit -m "Add your-app config"
dotfiles push
```

---

## 🎯 Next Steps

1. **Customize:** Modify configs in `~/.config/nvim`, `~/.config/zsh/`, etc.
2. **Track:** Use `dotfiles add` to version control your changes
3. **Share:** Push to GitHub to sync across machines
4. **Extend:** Add more configs from `~/.config/` as needed

---

## 📚 Resources

- **Zsh Manual:** https://zsh.sourceforge.io/Doc/
- **Neovim Docs:** https://neovim.io/doc/user/
- **Bare Git Repos Guide:** https://www.atlassian.com/git/tutorials/dotfiles
- **FZF:** https://github.com/junegunn/fzf
- **Zoxide:** https://github.com/ajeetdsouza/zoxide

---

## 💡 Tips

- Use `dotfiles status` frequently to see what's changed
- Commit often with meaningful messages
- Use `dotfiles log` to browse history
- Pull before starting work on a new machine: `dotfiles pull`
- Test configs before committing major changes

---

**Happy dotting! 🎉**
