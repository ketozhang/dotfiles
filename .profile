# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.

# Load the shell-specific rc file for the user's configured shell.
case "${SHELL##*/}" in
    bash)
        if [ -f "$HOME/.bashrc" ]; then
            . "$HOME/.bashrc"
        fi
        ;;
    zsh)
        if [ -f "$HOME/.zshrc" ]; then
            . "$HOME/.zshrc"
        fi
        ;;
esac

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

. "$HOME/.cargo/env"

if [ -d "$HOME/linuxbrew/.linuxbrew/bin" ] ; then
    PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi
