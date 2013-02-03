## Initialize
# node.js with nave
#/Users/qluto/dev/src/nave/nave.sh use latest
#/Users/qluto/dev/src/nave/nave.sh use 0.4.2

# python virtualenv
#source ~/dev/default-python/bin/activate
source ~/local/python2.7/bin/activate
#source ~/local/python3.2/bin/activate

## Environment variable configuration
export LANG=ja_JP.UTF-8
export PATH=.:/usr/local/bin:/usr/local/sbin:$PATH
export MANPATH=$MANPATH
export EDITOR="vim"
export HOSTNAME=`hostname`
#export PYTHONPATH=/Users/qluto/dev/misc/python

## Default shell configuration
autoload colors
colors
export LSCOLORS=ExFxCxdxBxegedabagacad
#export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

local GREEN=$'%{\e[1;32m%}'
local YELLOW=$'%{\e[1;33m%}'
local BLUE=$'%{\e[1;34m%}'
local DEFAULT=$'%{\e[1;m%}'


## prompt
PROMPT=$'\n'$GREEN${USER}@${HOSTNAME}' '$YELLOW'%~ ${vcs_info_msg_0_}'$'\n'$DEFAULT'%(!.#.$) ' 
PROMPT2='[%n]> '
RPROMPT=''

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' formats '%{'${fg[red]}'%}[%s %b] %{'$reset_color'%}'
setopt prompt_subst

#case ${UID} in
#0)
#    #PROMPT="%B%{[31m%}%/#%{[m%}%b "
#    PROMPT=$'\n'$GREEN${USER}@${HOSTNAME}' '$YELLOW'%~ '$'\n'$DEFAULT'%(!.#.$) ' 
#    PROMPT2="%B%{[31m%}%_#%{[m%}%b "
#    SPROMPT="%B%{[31m%}%r is correct? [n,y,a,e]:%{[m%}%b "
#    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
#        PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
#    ;;
#*)
#    #PROMPT="%{[31m%}%/%%%{[m%} "
#    PROMPT=$'\n'$GREEN${USER}@${HOSTNAME}' '$YELLOW'%~ '$'\n'$DEFAULT'%(!.#.$) '
#    PROMPT2="%{[31m%}%_%%%{[m%} "
#    SPROMPT="%{[31m%}%r is correct? [n,y,a,e]:%{[m%} "
#    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
#        PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
#    ;;
#esac
zstyle ':completion:*:default' list-colors ${LS_COLORS}

# z
. `brew --prefix`/Cellar/z/1.4/etc/profile.d/z.sh

# report on command which takes long time
REPORTTIME=3
TIMEFMT="\
The name of this job.             :%J
CPU seconds spent in user mode.   :%U
CPU seconds spent in kernel mode. :%S
Elapsed time in seconds.          :%E
The CPU persentage.               :%P"

# alert on command which takes long time
# original source : http://gist.github.com/396902
local COMMAND=""
local COMMAND_TIME=""
local HOSTNAME=`hostname`
case $TERM in
  xterm-256color)
    preexec(){
      COMMAND="${1}"
      if [ "`perl -e 'print($ARGV[0]=~/ssh|^vi|exit/)' $COMMAND`" -ne 1 ] ; then
        COMMAND_TIME=`date +%s`
        echo -ne "\ek${1%% *}:$HOSTNAME\e\\"
      fi
    }
    precmd(){
      z --add "$(pwd -P)"
      if [ "$COMMAND_TIME" -ne "0" ] ; then
        local d=`date +%s`
        d=`expr $d - $COMMAND_TIME`
        if [ "$d" -ge "5" ] ; then
          COMMAND="$COMMAND "
          growlnotify -t "${${(s: :)COMMAND}[1]}" -m "$COMMAND"
          echo "this command takes $d seconds.\n";
          echo -ne "\a"
        fi
      fi
      COMMAND="0"
      COMMAND_TIME="0"
      echo -ne "\ek$HOSTNAME\e\\"
    }
    ;;
  *)
    precmd(){
    }
    preexec(){
    }
    ;;
esac

# auto change directory
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
setopt auto_pushd

# command correct edition before each completion attempt
setopt correct

# compacked complete list display
setopt list_packed

# no beep sound when complete list displayed
setopt nolistbeep

# no beep when happen command-input-error
setopt no_beep

## Keybind configuration
# emacs like keybind (e.x. Ctrl-a goes to head of a line and Ctrl-e goes 
#   to end of it)
bindkey -e

# historical backward/forward search with linehead string binded to ^P/^N
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

## Command history configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

## Completion configuration
fpath=(~/.zsh/functions/Completion $fpath)
autoload -U compinit
compinit

# set terminal title including current directory
case "${TERM}" in
kterm*|xterm)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
esac 


## Alias
where='command -v'
alias ls="ls -FG"
alias l="ls -alhFG"
alias ll="ls -alhFG"
alias scrr='screen -U -D -RR'
alias s='screen -U'
alias tmux='tmux -2 attach || tmux -2'
alias autocompress='~/local/src/gist-1460871/autocompress.sh'

# Abbreviation
typeset -A myabbrev
myabbrev=(
    "ll"    "| less"
    "lg"    "| grep"
    "lv"    "| vim -R -"
    "tx"    "tar -xvzf"
    "gl"    "grep -irl"
    "ev"    " 2> /dev/null"
    "vv"    " >/dev/null 2>&1"
)

my-expand-abbrev() {
    local left prefix
    left=$(echo -nE "$LBUFFER" | sed -e "s/[_a-zA-Z0-9]*$//")
    prefix=$(echo -nE "$LBUFFER" | sed -e "s/.*[^_a-zA-Z0-9]\([_a-zA-Z0-9]*\)$/\1/")
    LBUFFER=$left${myabbrev[$prefix]:-$prefix}" "
}
zle -N my-expand-abbrev
bindkey     " "         my-expand-abbrev

# scrape '/hoge/fuga' to '/hoge/' when type Ctrl-w
export WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm


## Grep
#if type ggrep > /dev/null 2>&1; then
#  alias grep=ggrep
#fi
#export GREP_OPTIONS
#GREP_OPTIONS="--binary-files=without-match"
#GREP_OPTIONS="--directories=recurse $GREP_OPTIONS"
#GREP_OPTIONS="--exclude=\*.tmp $GREP_OPTIONS"
#if grep --help | grep -q -- --exclude; then
#  GREP_OPTIONS="--exclude=*/.svn/* $GREP_OPTIONS"
#  GREP_OPTIONS="--exclude=*/.git/* $GREP_OPTIONS"
#  GREP_OPTIONS="--exclude=*/CVS/* $GREP_OPTIONS"
#  GREP_OPTIONS="--exclude=*/.tags* $GREP_OPTIONS"
#fi
#if grep --help | grep -q -- --color; then
#  GREP_OPTIONS="--color=auto $GREP_OPTIONS"
#fi


## ssh on screen or tmux
if [ $TERM = xterm-256color ]; then
  ssh(){
    eval server=\${$#}
    screen -t $server ssh "$@"
    # tmux new-window -n $@ "exec ssh $@"
  }
  alias normalssh='/usr/bin/ssh'
fi

