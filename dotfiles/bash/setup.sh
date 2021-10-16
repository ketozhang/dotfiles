DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Register .bashrc
grep -r ".*/profile/dotfiles/bash/.bashrc" ~/.bashrc
if [[ $? -ne 0 ]]; then
	echo ". $DIR/.bashrc" >> ~/.bashrc
fi

# Register .inputrc
ln -s -v $DIR/.inputrc $HOME/.inputrc
