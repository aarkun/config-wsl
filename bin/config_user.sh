#!/bin/sh
set -e

echo -e '\nexport GPG_TTY=$(tty)' >> ~/.profile
echo '' >> ~/.profile
cat bin/start_ssh-agent.sh >> ~/.profile
echo 'AddKeysToAgent yes' > ~/.ssh/config
