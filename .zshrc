# load secrets
source "$HOME/dotfiles/secrets.sh"

# XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# update PATH
export PATH="$HOME/.local/bin:$PATH"

# ALIASES
alias ls='eza'
alias ll='eza -al --icons=auto --hyperlink --group-directories-first --git --time-style=long-iso --no-user'
alias tree='eza -aT --group-directories-first --git-ignore'

# old ls aliases
#alias ll='ls -alFhG'

## GIT
alias g='git'
alias gs='git status -s'
alias gd='git diff'
alias ga='git add'
alias gb='git branch'
alias gl='git log --oneline'
alias gm='git checkout main'

## HOMEBREW
alias b='brew'
alias bs='brew search'
alias bi='brew info'
alias bu='brew update'
alias bc='brew upgrade -ng'
alias bg='brew upgrade' # --no-quarantine'
alias bg-all='brew upgrade -g' # --no-quarantine'

# homebrew completions
autoload -Uz compinit
compinit

# starship cross-shell prompt
eval "$(starship init zsh)"

# fzf config
source <(fzf --zsh)

# zoxide config
export _ZO_DATA_DIR=$XDG_DATA_HOME
eval "$(zoxide init --cmd cd zsh)"

# api keys
export MISTRAL_API_KEY=$DOTFILES_API_MISTRAL
