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
# Download Antidote
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
# Download fzf
FZF_INSTALL_DIR=$HOME/.fzf
FZF_VERSION=v0.71.0
[[ -r $FZF_INSTALL_DIR ]] || git clone --depth 1 --branch ${FZF_VERSION}  https://github.com/junegunn/fzf.git $FZF_INSTALL_DIR

# Install fzf
[[ -r "$FZF_INSTALL_DIR/fzf.zsh" ]] || "$FZF_INSTALL_DIR/install" --no-key-bindings --no-completion --no-update-rc --no-bash --no-fish 1> /dev/null
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load fzf
eval "$(fzf --zsh)"

autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit
ZSH_AUTOSUGGEST_STRATEGY=( history completion )
zstyle ':completion:*' menu no # Disable default menu, in favor of fzf-tab

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


[[ -r $HOME/.linuxbrew ]] && eval "$($HOME/.linuxbrew/bin/brew shellenv)"
[[ -r /home/linuxbrew/.linuxbrew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
