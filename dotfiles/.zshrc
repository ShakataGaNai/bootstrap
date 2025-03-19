# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

DEFAULT_USER=`whoami`

if [[ "$ZPROF" = true ]]; then
    zmodload zsh/zprof
fi

if [ `uname` = 'Darwin' ]; then
    #OSX Specific
    MACOS=1
elif [ `uname` = 'Linux' ]; then
    #Linux Specific
    LINUX=1
fi

export ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

# zsh-completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
fi

plugins=(git command-not-found sudo python)

# function precmd() {
#   H=$(hostname)
#   if [[ ${#H} -gt 9 ]]; then
#     HO="${H:0:3}...${H: -3}"
#   else
#     HO=$H
#   fi
#   title " $HO:%~% "
# }


#if [ "$(ls -A ~/.aws)" ]; then
# plugins=( aws )
#fi

if type "kubectl" > /dev/null; then
    if [ $(kubectl config get-contexts|wc -l) -gt 1 ]; then
        plugins=( kubectl )
  fi
fi

if [[ -d "/usr/share/zsh/vendor-completions" ]]; then
    fpath=(/usr/share/zsh/vendor-completions $fpath)
fi


# keys=`ssh-add -l 2>&1`
# if echo $keys|grep -q "agent" ; then
#  eval `ssh-agent -s`
# fi

# setopt +o nomatch
# if [ -d ~/.ssh/ ]; then
#  for i in ~/.ssh/id_*.pub; do
#   if [ -f $i ]; then
#    if ! echo "$keys" | grep -q "${i%.pub}" ; then
#     ssh-add "${i%.pub}"
#    fi
#   fi
#  done
# fi

export UPDATE_ZSH_DAYS=7
export HIST_STAMPS="yyyy-mm-dd"
source $ZSH/oh-my-zsh.sh
export MICRO_TRUECOLOR=1

plugin=(battery iterm2)
export PATH="/opt/homebrew/bin:/usr/local/sbin:/usr/local/opt/go/libexec/bin:/opt/homebrew/opt/coreutils/libexec/gnubin:/usr/local/opt/curl/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/snap/bin:$HOME/.local/bin/:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
eval $(gdircolors ~/.dircolors.256dark)


TF_ALIAS=fuck alias fuck='eval $(thefuck $(fc -ln -1 | tail -n 1)); fc -R'
alias pwgen="pwgen -Cs 30 1"
alias python="python3"
#alias awsprof=". awsprof"

unsetopt share_history

# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# DISABLE_LS_COLORS="true"
DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
# export ARCHFLAGS="-arch x86_64"
# export SSH_KEY_PATH="~/.ssh/dsa_id"
# For a full list of active aliases, run `alias`.
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"




alias lols="ls | lolcat"
alias ls="lsd --color=always"

if [[ "$ZPROF" = true ]]; then
    zprof
fi

profzsh() {
    shell=${1-$SHELL}
    ZPROF=true $shell -i -c exit
}

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ${HOME}/.iterm2_shell_integration.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
