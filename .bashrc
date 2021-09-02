#   ┌┐ ┌─┐┌─┐┬ ┬┬─┐┌─┐
#   ├┴┐├─┤└─┐├─┤├┬┘│
#   └─┘┴ ┴└─┘┴ ┴┴└─└─┘

# If not running interactively, don't do anything.
case $- in
*i*) ;;
*) return ;;
esac

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options.
HISTCONTROL=ignoreboth:erasedups

# Append to the history file, don't overwrite it.
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1).
HISTSIZE=10000
HISTFILESIZE=100000

# Check the window size after each command and, if necessary, update the
# values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
# shopt -s globstar

# Make less more friendly for non-text input files, see lesspipe(1).
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot you work in (used in the prompt below).
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set a fancy prompt (non-color, unless we know we "want" color).
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# Uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1="${debian_chroot:+($debian_chroot)}\[\033[00;33m\]\u@\h\[\033[00m\]:\[\033[00;36m\]\w\[\033[00m\] \n$ "

else
    PS1="${debian_chroot:+($debian_chroot)}\u@\h:\w \n$ "
fi


# Save and reload the history after each command finishes. Also, add an empty line
# after each command.
PROMPT_COMMAND="printf '\n' && history -a && history -c && history -r; $PROMPT_COMMAND"

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir.
case "$TERM" in
xterm* | rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*) ;;

esac

# Add an "alert" alias for long running commands.  Use like so:
#  sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like—
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

##############################################
# ALIASES
##############################################

# Enable color support of ls and also add handy aliases.
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="ls --color=auto"
    alias dir="dir --color=auto"
    alias vdir="vdir --color=auto"

    alias grep="grep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias egrep="egrep --color=auto"
fi

# Colored GCC warnings and errors.
# export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# Some more ls aliases.

## Git.

# Git push origin.
alias gp="git push origin HEAD"

# Clears all the branches other than the current branch, 'main', 'master' & 'staging'.
alias brclr="git branch | grep -Ev 'main|master|staging' | xargs -I{} git branch -D '{}'"

# Splits the name of the current branch by '_' and picks the first token.
alias brpre="git branch --show-current | xargs -d '_' -n 1 2>/dev/null | head -n 1"

# Opens all the files changed in the current branch.
alias last_changed="git diff-tree --no-commit-id --name-only -r HEAD | xargs code"

## Unix magics
alias sudo="sudo "
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -iv"
alias hs="history|grep"
alias ls="ls --group-directories-first --color=auto"
alias ping="ping -c5"
alias pkill="pkill -ecfi"
alias update="sudo apt update && sudo apt upgrade && sudo apt autoclean && sudo apt autoremove"
alias www="python3 -m http.server 8001"

# Languages.
PATH=$PATH:/usr/local/go/bin

# Work.
alias dj_dendi="curl -s https://raw.githubusercontent.com/rednafi/dotfiles/master/scripts/dj_dendi.sh | bash"

# Docker
start_redis() {
    echo "Spinning up a Redis container..."
    echo "================================"
    echo
    stop_redis
    command docker run --name dev-redis -d -h localhost -p 6379:6379 redis:alpine
    echo
}

stop_redis() {
    echo
    command docker stop dev-redis
    command docker rm dev-redis
    echo
}

start_rabbit() {
    echo "Spinning up a Rabbitmq container..."
    echo "==================================="
    echo
    stop_rabbit
    command docker run -d \
        --hostname my-rabbit \
        --name dev-rabbit \
        -p 15672:15672 \
        -p 5672:5672 \
        --memory 512m \
        -e RABBITMQ_DEFAULT_USER=ubuntu \
        -e RABBITMQ_DEFAULT_PASS=debian \
        -e RABBITMQ_VM_MEMORY_HIGH_WATERMARK=0.8 \
        rabbitmq:3-management
    echo
}

stop_rabbit() {
    echo
    command docker stop dev-rabbit
    command docker rm dev-rabbit
    echo
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
