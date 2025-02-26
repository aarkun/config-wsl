#!/bin/sh
set -e

echo -e '\nexport GPG_TTY=$(tty)' >> ~/.profile
echo '' >> ~/.profile
cat bin/start_ssh-agent.sh >> ~/.profile
echo 'AddKeysToAgent yes' > ~/.ssh/config
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
echo -e '\nsource "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
echo 'source "$HOME/.asdf/completions/asdf.bash" ' >> ~/.bashrc
