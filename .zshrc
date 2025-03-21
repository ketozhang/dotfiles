if [[ -n "$ZSH_DEBUGRC" ]]; then
  zmodload zsh/zprof
fi
ZSH_HOME=$HOME/.zsh

########################################################################################
# Plugin Manager
########################################################################################

# Download Znap, if it's not there yet.
[[ -r $ZSH_HOME/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git $ZSH_HOME/znap
source $ZSH_HOME/znap/znap.zsh  # Start Znap

########################################################################################
# Environment
########################################################################################
source  $HOME/.global.env
source  $HOME/.secrets.env
source  $HOME/.env

########################################################################################
# Prompt
########################################################################################
znap prompt sindresorhus/pure

########################################################################################
# Plugins
########################################################################################
# znap source marlonrichert/zsh-autocomplete
znap source xylous/gitstatus
znap source zsh-users/zsh-syntax-highlighting
znap install zsh-users/zsh-completions
znap source zsh-users/zsh-autosuggestions
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
znap eval fzf 'fzf --zsh'
znap source Aloxaf/fzf-tab
zstyle ':completion:*' menu no # Disable default menu, in favor of fzf-tab
########################################################################################
# INSTALL COMPLETIONS
########################################################################################
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

znap function _pip_completion pip       'eval "$( pip3 completion --zsh )"'
compctl -K    _pip_completion pip

if command -v "aws_completer" &> /dev/null; then
  aws_completer
fi

znap function _aws_completion aws       'eval "$(complete -C '/usr/local/bin/aws_completer' aws)"'
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

