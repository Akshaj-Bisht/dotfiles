# dotfiles

My Linux desktop and development config files.

## Install

Run the installer directly from GitHub:

```bash
curl -fsSL https://raw.githubusercontent.com/Akshaj-Bisht/dotfiles/main/install.sh | bash
```

When run interactively, the installer asks what to install. In non-interactive
mode it installs all components.

### Install Everything

```bash
bash install.sh --all
```

### Pick Components

```bash
bash install.sh --select
```

Or pass a comma-separated list:

```bash
bash install.sh --components doom,kitty,foot,mango
```

Available components:

```text
zsh
nvim
doom
kitty
foot
niri
mango
dev
```

Use `--no-packages` to only check out config files without installing system
packages:

```bash
bash install.sh --components doom,kitty,foot --no-packages
```

## What The Installer Does

- Installs packages for the selected components.
- Clones this repo as a bare repo at `~/dotfiles`.
- Checks out only the selected config paths.
- Adds the `dotfiles` git alias to `~/.config/zsh/aliases.zsh`.
- Runs component setup, such as `doom sync` when Doom Emacs is selected.

## Manual Setup

```bash
git clone --bare git@github.com:Akshaj-Bisht/dotfiles.git "$HOME/dotfiles"
alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'
dotfiles checkout
dotfiles config status.showUntrackedFiles no
```

If checkout reports conflicts, move the existing files aside and run
`dotfiles checkout` again.

## Useful Commands

```bash
dotfiles status
dotfiles add .config/kitty .config/foot .config/doom
dotfiles commit -m "Update configs"
dotfiles push origin main
```
