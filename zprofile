# vim: ai et ts=4 sts=4 ft=sh

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

# plenv
export PATH="$HOME/.plenv/bin:$PATH"
eval "$(plenv init -)"

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

# n (node)
export N_PREFIX="$HOME/.n"
export PATH="$HOME/.n/bin:$PATH"
n 8.4.0

# rakudobrew
export PATH="$HOME/.rakudobrew/bin:$PATH"
eval "$(/Users/cdaniel/.rakudobrew/bin/rakudobrew init -)"

# yarn
export PATH="$HOME/.yarn/bin:$PATH"

# init z! (https://github.com/rupa/z)
source ~/.z.sh

alias gg='git status -sb'

# Antigen ZSH config
source ~/.antigen.zsh
antigen use oh-my-zsh
antigen bundle git
antigen bundle mollifier/cd-gitroot
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle mafredri/zsh-async
antigen apply

# Aliases
alias cdu="cd-gitroot"

# un-share history
unsetopt share_history

# Set prompt
PROMPT='%{$FG[245]%}%n@%m %{$FG[172]%}λ %{$FG[067]%}%~/ %{$reset_color%}'
RPROMPT='%{$FG[241]%}$(git_prompt_info)%{$reset_color%} $(git_prompt_status)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[022]%}✈"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[142]%}✭"
ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[088]%}✗"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[025]%}➦"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[130]%}✂"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[066]%}✱"

# syntax highlighting colours
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=217'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=153'

ZSH_HIGHLIGHT_STYLES[command]='fg=white'
ZSH_HIGHLIGHT_STYLES[alias]='fg=white'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=white'
ZSH_HIGHLIGHT_STYLES[function]='fg=white'

