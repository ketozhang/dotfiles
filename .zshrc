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
