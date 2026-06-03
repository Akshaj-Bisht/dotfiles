# =========================================================
# History
# =========================================================
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# =========================================================
# Shell behaviour
# =========================================================

setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT

# =========================================================
# Smart directory navigation
# =========================================================

eval "$(zoxide init zsh)"

# =========================================================
# Completion
# =========================================================

autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# =========================================================
# Bun
# =========================================================

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# =========================================================
# fnm
# =========================================================

FNM_PATH="$HOME/.local/share/fnm"

if [[ -d "$FNM_PATH" ]]; then
    export PATH="$FNM_PATH:$PATH"
    eval "$(fnm env --use-on-cd)"
fi

# =========================================================
# Extra environment
# =========================================================

[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

[[ -s "$HOME/.config/envman/load.sh" ]] && \
    source "$HOME/.config/envman/load.sh"

# =========================================================
# fzf
# =========================================================

# macOS (Apple Silicon)
[[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]] && {
    source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
    source /opt/homebrew/opt/fzf/shell/completion.zsh
}

# macOS (Intel)
[[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]] && {
    source /usr/local/opt/fzf/shell/key-bindings.zsh
    source /usr/local/opt/fzf/shell/completion.zsh
}

# Arch Linux
[[ -f /usr/share/fzf/key-bindings.zsh ]] && {
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
}

# Ubuntu
[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && {
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh
}

# =========================================================
# Modular configuration
# =========================================================

source "$ZDOTDIR/fzf.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/bindings.zsh"
source "$ZDOTDIR/plugins.zsh"
source "$ZDOTDIR/prompt.zsh"
