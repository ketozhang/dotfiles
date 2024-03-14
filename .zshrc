ZSH_HOME=$HOME/.zsh

########################################################################################
# Plugin Manager
########################################################################################

# Download Znap, if it's not there yet.
[[ -r $ZSH_HOME/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git $ZSH_HOME/znap
source $ZSH_HOME/znap/znap.zsh  # Start Znap

################################################################################
# Environment
################################################################################
export XDG_CONFIG_HOME=$HOME/.config

########################################################################################
# Prompt
########################################################################################
znap prompt sindresorhus/pure

########################################################################################
# Plugins
########################################################################################
znap source marlonrichert/zsh-autocomplete

ZSH_AUTOSUGGEST_STRATEGY=( history completion )
znap source zsh-users/zsh-autosuggestions

znap source zsh-users/zsh-syntax-highlighting


########################################################################################
# Completion
########################################################################################
znap install zsh-users/zsh-completions

znap function _pip_completion pip       'eval "$( pip completion --zsh )"'
compctl -K    _pip_completion pip

znap function _aws_completion aws       'eval "$(complete -C '/usr/local/bin/aws_completer' aws)"'
compctl -K    _aws_completion aws

