[[ $- != *i* ]] && return

alias ls='ls --color=auto'

alias ll='eza \
-l -X \
--color-scale=all --icons --no-quotes --hyperlink \
--group-directories-first \
-b -h --time-style="+%H:%M %d %b %Y" --total-size --no-permissions --no-user'

alias la='eza \
-l -X \
--color-scale=all --icons --no-quotes --hyperlink \
-a --group-directories-first \
-b -h --time-style="+%H:%M %d %b %Y" --total-size --no-permissions --no-user'

alias grep='grep --color=auto'

cl() {
    cd "$@" && ll
}

srv() {
    php -S "localhost:${1:-8000}"
    echo
}

clear() {
    __prompt_count=0
    command clear
}

alias c='clear'

alias ..='cl ..'
alias ...='cl ../..'
alias ....='cl ../../..'

__prompt_count=0

__set_prompt_separator() {
    if (( __prompt_count > 0 )); then
        __prompt_separator=$'\n'
    else
        __prompt_separator=""
    fi
    (( __prompt_count++ ))
}

PROMPT_COMMAND="__set_prompt_separator${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

PS1='${__prompt_separator}'
PS1+='\[\e[1;32m\]\w\[\e[0m\]'
PS1+='\n'
PS1+='\[\e[1;32m\]❯ \[\e[0m\]'
