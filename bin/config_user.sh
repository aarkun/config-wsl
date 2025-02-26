#!/bin/sh
set -e

echo -e '\nexport GPG_TTY=$(tty)' >> ~/.profile

echo '' >> ~/.profile
cat bin/start_ssh-agent.sh >> ~/.profile
echo 'AddKeysToAgent yes' > ~/.ssh/config

ASDF_VERSION=v0.16.4
ASDF_INSTALLATION_FILE=asdf-$ASDF_VERSION-linux-amd64.tar.gz
curl -L -O --output-dir /tmp \
     "https://github.com/asdf-vm/asdf/releases/download/$ASDF_VERSION/$ASDF_INSTALLATION_FILE{,.md5}"
grep $(md5sum /tmp/$ASDF_INSTALLATION_FILE | cut -d ' ' -f 1) /tmp/$ASDF_INSTALLATION_FILE.md5
mkdir -p ~/.local/bin
tar -C ~/.local/bin -x -f /tmp/$ASDF_INSTALLATION_FILE
echo -e '\nPATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"' >> ~/.profile
echo -e '\n. <(asdf completion bash)' >> ~/.bashrc
