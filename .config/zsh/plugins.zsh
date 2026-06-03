# Antidote
source "$ZDOTDIR/plugins/antidote/antidote.zsh"

# Generate plugin bundle if missing
if [[ ! -f "$ZDOTDIR/.zsh_plugins.zsh" ]]; then
    antidote bundle < "$ZDOTDIR/plugins.txt" > "$ZDOTDIR/.zsh_plugins.zsh"
fi

# Load bundled plugins
source "$ZDOTDIR/.zsh_plugins.zsh"

# fzf-tab configuration
zstyle ':fzf-tab:*' use-fzf-default-opts yes
