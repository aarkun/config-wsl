#!/bin/sh
set -e

echo 'export GPG_TTY=$(tty)' >> ~/.bashrc
echo '' >> ~/.profile
cat bin/start_ssh-agent.sh >> ~/.profile
echo 'AddKeysToAgent yes' > ~/.ssh/config
