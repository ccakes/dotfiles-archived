# vim: ai et ts=4 sts=4 ft=sh

export LC_ALL=en_US.UTF-8
export TERM=xterm-256color
[ -n "$TMUX" ] && export TERM=screen-256color

autoload -Uz compinit promptinit
compinit
promptinit

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" down-line-or-beginning-search

# init z! (https://github.com/rupa/z)
source ~/.z.sh

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

# Antigen ZSH config
source ~/.antigen.zsh
antigen use oh-my-zsh
antigen bundle mollifier/cd-gitroot
antigen bundle mafredri/zsh-async
antigen bundle djui/alias-tips
antigen bundle zsh-users/zsh-autosuggestions
antigen apply

# Aliases
alias cdu="cd-gitroot"
alias gg='git status -sbu'
alias gd="git diff"
alias gp="git push"
alias keybase="$HOME/.go/bin/keybase -s https://api.keybase.io --standalone"

alias cperl="carton exec -- perl"
alias cprove="carton exec -- prove"
alias csqitch="carton exec -- sqitch"
alias cmorbo="carton exec -- morbo"

# Kind-of Aliases
function gl {
  if [ -d "$(pwd)/.git" ]; then
    git pull $@
  else
    git clone $@
  fi
}

# un-share history
unsetopt share_history

# Setup direnv if available
# https://github.com/direnv/direnv
if (( ${+commands[direnv]} )); then
  eval "$(direnv hook zsh)"
fi

#######################
# Init lang envs
[ -d "$HOME/.cargo" ] && export PATH="$HOME/.cargo/bin:$PATH" # rust
[ -d "$(rustc --print sysroot)/lib/rustlib/src/rust/src" ] && export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
[ -d "$HOME/.yarn" ] && export PATH="$HOME/.yarn/bin:$PATH" # yarn (not a lang..)

# plenv
if [ -d "$HOME/.plenv" ]; then
  export PATH="$HOME/.plenv/bin:$PATH"
  eval "$(plenv init -)"
fi

# rbenv
if [ -d "$HOME/.rbenv" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# pyenv
if [ -d "$HOME/.pyenv" ]; then
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"
fi

# n (node)
if [ -d "$HOME/.n" ]; then
  export N_PREFIX="$HOME/.n"
  export PATH="$HOME/.n/bin:$PATH"
  n 10.10.0
fi

# go lang
if [ -d "$HOME/.go" ]; then
  export GOPATH="${HOME}/.go"
  export GOROOT="$(brew --prefix golang)/libexec"
  export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

  test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"
fi

# postgres@11
if [ -d "/usr/local/opt/postgresql@11/bin" ]; then
  # Intentionally at the end so when we install pg12 I don't get all confused...
  export PATH="$PATH:/usr/local/opt/postgresql@11/bin"
fi

#################
## Kitty
if [[ -x "$(which dark-mode)" && $TERMINFO == *kitty* ]]; then
  [ "$(dark-mode status)" = "on" ] && kitty @ set-colors -a /Users/cdaniel/Library/Preferences/kitty/kitty-themes/themes/PencilDark.conf || kitty @ set-colors -a /Users/cdaniel/Library/Preferences/kitty/kitty-themes/themes/PencilLight.conf
fi


#################
## Prompt
precmd() {
  setopt localoptions noshwordsplit extended_glob null_glob
  local -a prompt_parts
  local -a flags

  # Feels like a hack, but is nice and dynamic.
  local nexthop=$(/sbin/route -n get 131.115.0.1 2>/dev/null | grep gateway | awk '{print $2}')
  if [ "${nexthop:0:5}" = "10.79" ] || [ "${nexthop:0:5}" = "10.81" ]; then
    source ~/.proxyrc
  else
    unset HTTPS_PROXY HTTP_PROXY ALL_PROXY
  fi

  # Show user + host if SSH
  (( ${+SSH_TTY} )) && prompt_parts+=('%{$FG[245]%}%n@%m')

  prompt_parts+=('%{$FG[172]%}λ %{$FG[067]%}$(tico `dirs`)')

  # Add icon for direnv
  (( ${+DIRENV_DIFF} )) && flags+=("%{$FG[154]%}")
  # (( ${+DIRENV_DIFF} )) && flags+=("%{$FG[154]%}c")

  # Add icon for vaulted
  if (( ${+VAULTED_ENV} )); then
    EXP=$(date -ju -f '%FT%TZ' "$VAULTED_ENV_EXPIRATION" +'%s')
    NOW=$(date -u +%s)
    [[ $EXP -gt $NOW ]] && VCOL=112 || VCOL=124

    # If we have <300 secs remaining, show that too
    (( REM = $EXP - $NOW ))
    if [[ $REM -gt 0 && $REM -lt 300 ]]; then
      COUNTDOWN=" ${REM}s"
    fi

    flags+=("%{$FG[$VCOL]%}%{$FG[11]%}$COUNTDOWN")
    # flags+=("%{$FG[$VCOL]%}v%{$FG[11]%}$COUNTDOWN")
  fi

  # Git
  # local gbranch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  local gitdir=$(echo (../)#.git)
  if [ -d "$gitdir" ]; then
    RPROMPT=' %{$FG[242]%}$(git rev-parse --abbrev-ref HEAD 2>/dev/null)%{$reset_color%}'
    # RPROMPT=' %{$FG[242]%}$(git rev-parse --abbrev-ref HEAD 2>/dev/null)%{$reset_color%}'
  else
    unset RPROMPT
  fi

  # Languages (commented due to Kitty font issues)
  # [ -f "$( echo (../)#cpanfile(:a) )" ] && flags+=('%{$FG[242]%}')
  # [ -f "$( echo (../)#Cargo.toml(:a) )" ] && flags+=('%{$FG[242]%}')
  # [ -f "$( echo (../)#package.json(:a) )" ] && flags+=('%{$FG[242]%}')
  # [ -f "$( echo (../)#requirements.txt(:a) )" ] && flags+=('%{$FG[242]%}')
  (( $#flags > 0 )) && prompt_parts+=(${(j::)flags})

  prompt_parts+=('%{$reset_color%}')

  PROMPT="$prompt_parts"

  # PROMPT="${(j. .)preprompt_parts}"
  # PROMPT+='%{$reset_color%}'
}

eval $(thefuck --alias)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f "~/Library/Preferences/org.dystroy.broot/launcher/bash/br" ] && . ~/Library/Preferences/org.dystroy.broot/launcher/bash/br
