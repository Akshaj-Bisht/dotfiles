# dotfiles

My config files

## install

# Automated setup (one-liner)

```bash
curl -fsSL https://raw.githubusercontent.com/Akshaj-Bisht/dotfiles/main/install.sh | bash
```
# Or manual setup
```bash
git clone --bare https://github.com/Akshaj-Bisht/dotfiles.git ~/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dotfiles checkout
dotfiles config status.showUntrackedFiles no
```


