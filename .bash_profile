# perlbrew
source ~/.perlbrew/etc/bashrc

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

## bashstrap
# Color LS
colorflag="-G"
alias ls="command ls ${colorflag}"

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Git
# You must install Git first - ""
alias gg='git status -s'
alias gc='git commit -m' # requires you to type a commit message
alias gp='git push'
alias grm='git rm $(git ls-files --deleted)'

### Prompt Colors
# Modified version of @gf3’s Sexy Bash Prompt
# (https://github.com/gf3/dotfiles)
if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
	export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
	export TERM=xterm-256color
fi

if tput setaf 1 &> /dev/null; then
	tput sgr0
	if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
		BLACK=$(tput setaf 190)
		MAGENTA=$(tput setaf 9)
		ORANGE=$(tput setaf 215)
		YELLOW=$(tput setaf 190)
        GREEN=$(tput setaf 154)
		PURPLE=$(tput setaf 141)
		WHITE=$(tput setaf 0)
        GREY=$(tput setaf 245)
	else
		BLACK=$(tput setaf 190)
		MAGENTA=$(tput setaf 5)
		ORANGE=$(tput setaf 4)
        YELLOW=$(tput setaf 190)
		GREEN=$(tput setaf 148)
		PURPLE=$(tput setaf 1)
		WHITE=$(tput setaf 7)
        GREY=$(tput setaf 8)
	fi
	BOLD=$(tput bold)
	RESET=$(tput sgr0)
else
	BLACK="\033[01;30m"
	MAGENTA="\033[1;31m"
	ORANGE="\033[1;33m"
	GREEN="\033[1;32m"
	PURPLE="\033[1;35m"
	WHITE="\033[1;37m"
	BOLD=""
	RESET="\033[m"
fi

export BLACK
export MAGENTA
export ORANGE
export YELLOW
export GREEN
export PURPLE
export WHITE
export GREY
export BOLD
export RESET

# Git branch details
function parse_git_dirty() {
	[[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
}
function parse_git_branch() {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

# screen & tmux
export TERMMUX
if [ -n "$STY" ]; then TERMMUX=" (screen:$WINDOW)"; fi
if [ -n "$TMUX" ]; then TERMMUX=" (tmux:`tmux display-message -p '#I'`)"; fi

# Change this symbol to something sweet.
# (http://en.wikipedia.org/wiki/Unicode_symbols)
symbol="⚡ "

#export PS1="\[${BOLD}${MAGENTA}\]\u@\h \[$WHITE\]in \[$GREEN\]\w\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$PURPLE\]\$(parse_git_branch)\[$WHITE\]$TERMMUX\n$symbol\[$RESET\]"
export PS1="\[${ORANGE}\]\u@\h \[$GREY\]in \[$YELLOW\]\w\[$GREY\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$PURPLE\]\$(parse_git_branch)\[$GREEN\]$TERMMUX\[${BOLD}${GREY}\]\n$symbol\[$RESET\]"
export PS2="\[$ORANGE\]→ \[$RESET\]"


### Misc

# Only show the current directory's name in the tab
export PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/}\007"'

# init z! (https://github.com/rupa/z)
. ~/.z.sh
