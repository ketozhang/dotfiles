ZSH_HOME=$HOME/.zsh

###################################################################################
# Profiler
###################################################################################
if [[ -n "$ZSH_DEBUGRC" ]]; then
  zmodload zsh/zprof
fi

########################################################################################
# Plugin Manager
# Antidote is the plugin manager
# Update plugins by modifying the .zsh_plugins.txt file
########################################################################################
# Downlaod Antidote
ZSH_ANTIDOTE_VERSION=v2.0.12
ZSH_ANTIDOTE_DIR=$ZSH_HOME/antidote
[[ -r $ZSH_ANTIDOTE_DIR/antidote.zsh ]] || git clone --depth 1 --branch ${ZSH_ANTIDOTE_VERSION} --single-branch -- https://github.com/mattmc3/antidote.git $ZSH_HOME/antidote

# Load Antidote Option 1
# source $ZSH_HOME/antidote/antidote.zsh

# Load Antidote Option 2 (lazy load)
fpath=($ZSH_ANTIDOTE_DIR/functions $fpath)
autoload -Uz antidote

ZSH_PLUGINS=${ZDOTDIR:-$HOME}/.zsh_plugins

# Build antidote plugins to static plugins file
if [[ ! ${ZSH_PLUGINS}.zsh -nt ${ZSH_PLUGINS}.txt ]]; then
  antidote bundle <${ZSH_PLUGINS}.txt >|${ZSH_PLUGINS}.zsh
fi

# Activate plugins
source ${ZSH_PLUGINS}.zsh

########################################################################################
# Environment
########################################################################################
source  $HOME/.global.env
source  $HOME/.secrets.env
source  $HOME/.env

########################################################################################
# Prompt
########################################################################################
autoload -Uz promptinit && promptinit && prompt pure

########################################################################################
# Completions
########################################################################################
ZSH_AUTOSUGGEST_STRATEGY=( history completion )
# Reset history key bindings to Zsh default
# () {
#    local -a prefix=( '\e'{\[,O} )
#    local -a up=( ${^prefix}A ) down=( ${^prefix}B )
#    local key=
#    for key in $up[@]; do
#       bindkey "$key" up-line-or-history
#    done
#    for key in $down[@]; do
#       bindkey "$key" down-line-or-history
#    done
# }
eval "$(fzf --zsh)"
zstyle ':completion:*' menu no # Disable default menu, in favor of fzf-tab
########################################################################################
# INSTALL COMPLETIONS
########################################################################################
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

_pip_completion() {
  eval "$(pip3 completion --zsh)"
}
compctl -K    _pip_completion pip

if command -v "aws_completer" &> /dev/null; then
  aws_completer
fi

_aws_completion() {
  eval "$(complete -C '/usr/local/bin/aws_completer' aws)"
}
compctl -K    _aws_completion aws

########################################################################################
# Keybindings
########################################################################################
### ctrl+arrows
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
# urxvt
bindkey "\eOc" forward-word
bindkey "\eOd" backward-word

### ctrl+delete
bindkey "\e[3;5~" kill-word
# urxvt
bindkey "\e[3^" kill-word

### ctrl+backspace
bindkey '^H' backward-kill-word

### ctrl+shift+delete
bindkey "\e[3;6~" kill-line
# urxvt
bindkey "\e[3@" kill-line
################################################################################
if [[ -n "$ZSH_DEBUGRC" ]]; then
  zprof
fi


eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# START: Added by Updated Airflow Breeze autocomplete setup
source /home/keto/Projects/airflow/dev/breeze/autocomplete/breeze-complete-zsh.sh
# END: Added by Updated Airflow Breeze autocomplete setup
