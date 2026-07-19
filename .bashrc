[[ $- != *i* ]] && return

alias ls='ls --color=auto'

alias ll='eza \
-l -X \
--color-scale=all --icons --no-quotes --hyperlink \
--group-directories-first \
-b -h --time-style="+%d/%m/%y %H:%M" --no-permissions --no-user'

alias la='eza \
-l -X \
--color-scale=all --icons --no-quotes --hyperlink \
-a --group-directories-first \
-b -h --time-style="+%d/%m/%y %H:%M" --no-permissions --no-user'

alias lt='eza \
--tree -X \
--icons --no-quotes --hyperlink \
--group-directories-first'

alias grep='grep --color=auto'

cl() {
    cd "$@" && ll
}

srv() {
    php -S "localhost:${1:-8000}"
}

clear() {
    command clear
    unset __prompt_seen
}

alias c='clear'

alias ..='cl ..'
alias ...='cl ../..'
alias ....='cl ../../..'

__set_prompt_separator() {
    local row col
    IFS='[;' read -sdR -p $'\e[6n' _ row col
    if [[ -z "$__prompt_seen" ]]; then
        __prompt_separator=""
        __prompt_seen=1
    elif [[ "$col" != "1" ]]; then
        __prompt_separator=$'\n\n'
    else
        __prompt_separator=$'\n'
    fi
}

PROMPT_COMMAND="__set_prompt_separator${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

PS1='${__prompt_separator}'
PS1+='\[\e[1;34m\]\w\[\e[0m\]'
PS1+='\n'
PS1+='\[\e[1;32m\]❯ \[\e[0m\]'
