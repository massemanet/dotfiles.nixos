#!/usr/bin/env bash
# -*- mode: shell-script -*-
# ~/.bashrc: executed by bash(1) for non-login shells.
#
# debian style

# make scp work by checking for a tty
[ -t 0 ] || return

# clean up
unalias -a

# check terminal resize
shopt -s checkwinsize

# pretty colors
eval "$(dircolors)"

# nixos and bash-completion has some friction
# shellcheck source=completions.sh
[ -f "$HOME/completions.sh" ] && . "$HOME/completions.sh"

# define some git helpers
# shellcheck source=bin/gitfunctions
[ -f ~/bin/gitfunctions ] && . ~/bin/gitfunctions

# emacs
export EDITOR="emacsclient -ct -a ''"

# PS1
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWDIRTYSTATE=true
export PROMPT_COMMAND='prompt_exit LX; prompt_ps ; prompt_nix _NIX_ENV; prompt_history'
if [ -f ~/.kube/config ] && test "$(command -v kubectl)" ; then
    PROMPT_COMMAND+='; prompt_k8s K8S'
fi
export PS=""
# shellcheck disable=SC2016
if [ "$TERM" != "dumb" ]; then
    # set a fancy prompt
    PS='\[\e[31m\]${_NIX_ENV:+$_NIX_ENV:}'
    PS+='\[\e[33m\]\h'
    PS+='\[\e[34m\]${K8S:+[${K8S}]}'
    PS+='\[\e[36m\]${AWS_VAULT:+[${AWS_VAULT}]}'
    PS+='\[\e[35m\]($(mygitdir):$(mygitbranch))'
    PS+='\[\e[32m\]${LX:+\[\e[31m\]($LX)}$'
    PS+='\[\e[0m\] '
else
    PS="\\h\\$ "
fi

please() { sudo $(fc -ln -1); }

dir()  { ls -AlFh --color "$@"; }
dirt() { dir -rt "$@"; }
dird() { dir -d "$@"; }
rea()  { history | grep -E "${@:-}"; }
c()    { cat "$@"; }
g()    { grep -nIHE --color "$@"; }
m()    { less "$@"; }

prompt_exit() {
    eval "$1='$?'; [ \$$1 == 0 ] && unset $1"
}

prompt_ps() {
    export PS1="$PS"
}

prompt_nix() {
    eval "$1='$(echo "${name:-""}" | cut -f-2 -d"-")'"
}

prompt_history() {
    history -a
}

prompt_k8s() {
    eval "$1='$(grep -o "current-context.*" ~/.kube/config | cut -c18-)'"
}

## history
# lots of history
export HISTSIZE=9999
export HISTFILESIZE=$HISTSIZE

# agglomerate history from multiple shells
export HISTCONTROL="ignoredups"
shopt -s histappend

#the below will make all commands visible in all shells
#PROMPT_COMMAND="$PROMPT_COMMAND ; history -a ; history -c; history -r"

# multi-line commands
shopt -s cmdhist

# motd
uname -a
