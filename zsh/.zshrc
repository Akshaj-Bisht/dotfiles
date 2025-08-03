autoload_package() {
  for pkg in "$@"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
      echo "📦 Installing missing package: $pkg"
      sudo pacman -S --noconfirm "$pkg"
    fi
  done
}

# ── Zinit Setup ───────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")"
[ ! -d "$ZINIT_HOME/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "$ZINIT_HOME/zinit.zsh"

# ── Plugins ───────────────────────────────────────
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light junegunn/fzf

# ── OMZ Plugin Snippets ───────────────────────────
zinit snippet OMZP::docker
zinit snippet OMZP::git
zinit snippet OMZP::docker-compose
zinit snippet OMZP::kubectl
zinit snippet OMZP::npm
zinit snippet OMZP::pip
zinit snippet OMZP::command-not-found
zinit snippet OMZP::sudo

# ── Starship Prompt ───────────────────────────────
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# ── FZF Shell Integration ─────────────────────────
[[ -f ~/.fzf/shell/key-bindings.zsh ]] && source ~/.fzf/shell/key-bindings.zsh
[[ -f ~/.fzf/shell/completion.zsh ]] && source ~/.fzf/shell/completion.zsh

export FZF_DEFAULT_OPTS="
--height 40%
--layout=reverse
--border
--preview 'bat --style=numbers --color=always --line-range :100 {} || tree -C {} || ls -l {}'
"

if ! command -v bat >/dev/null && command -v batcat >/dev/null; then
  alias bat="batcat"
fi

# ── FZF Helpers ───────────────────────────────────
alias fcd='cd "$(find . -type d 2>/dev/null | fzf)"'
alias fgrep='rg --files | fzf --preview "bat --style=numbers --color=always --line-range :100 {}"'

# ── Completion & Replay ───────────────────────────
autoload -Uz compinit && compinit
zinit cdreplay -q

# ── Keybindings ───────────────────────────────────
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# ── History Settings ──────────────────────────────
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ── Completion Styling ────────────────────────────
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# ── Aliases ───────────────────────────────────────
alias ls="eza --icons --color=always -a"
alias ll="eza --icons --long --git -a"
alias lt="eza --icons --tree -a -L 2"
alias c='clear'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
