#!/bin/sh
set -e

if [ $(id -u) -eq 0 ]; then
    echo "You should not be root"
    exit 1
fi

cp /etc/skel/.profile ~
cp /etc/skel/.bashrc ~

PATH="$HOME/.local/bin:$PATH"

echo '\nexport GPG_TTY=$(tty)' >> ~/.profile

echo '' >> ~/.profile
cat bin/start_ssh-agent.sh >> ~/.profile
mkdir -p ~/.ssh
echo 'AddKeysToAgent yes' > ~/.ssh/config

mkdir -p ~/.local/bin
ln -fs "/mnt/c/Users/$USER/AppData/Local/Microsoft/WindowsApps/firefox.exe" \
   ~/.local/bin/firefox

ASDF_VERSION=v0.16.4
ASDF_INSTALLATION_FILE=asdf-$ASDF_VERSION-linux-amd64.tar.gz
curl -L -O --output-dir /tmp \
     "https://github.com/asdf-vm/asdf/releases/download/$ASDF_VERSION/$ASDF_INSTALLATION_FILE{,.md5}"
grep $(md5sum /tmp/$ASDF_INSTALLATION_FILE | cut -d ' ' -f 1) \
     /tmp/$ASDF_INSTALLATION_FILE.md5
mkdir -p ~/.local/bin
tar -C ~/.local/bin -x -f /tmp/$ASDF_INSTALLATION_FILE
PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
echo '\nPATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"' >> ~/.profile
echo '\n. <(~/.local/bin/asdf completion bash)' >> ~/.bashrc
echo 'legacy_version_file = yes' > ~/.asdfrc

asdf plugin add kubectl
asdf install kubectl latest
asdf set -u kubectl latest
echo '\n. <(kubectl completion bash)' >> ~/.profile

asdf plugin add helm
asdf install helm 3.17.1
asdf set -u helm 3.17.1
echo '\n. <(helm completion bash)' >> ~/.profile

asdf plugin add make
asdf install make latest
asdf set -u make latest

asdf plugin add python
asdf install python 3.11.11
asdf set -u python 3.11.11

asdf plugin add azure-cli
asdf install azure-cli latest
asdf set -u azure-cli latest

asdf plugin add golang

asdf plugin add java
asdf install java temurin-21.0.5+11.0.LTS
asdf set -u java temurin-21.0.5+11.0.LTS

asdf plugin add maven
asdf install maven latest

asdf plugin add gradle

asdf plugin add nodejs

asdf plugin add pnpm

IDEA_INSTALLATION_FILE=ideaIU-2024.3.3.tar.gz
curl -O --output-dir /tmp \
     "https://download-cdn.jetbrains.com/idea/$IDEA_INSTALLATION_FILE{,.sha256}"
grep $(sha256sum /tmp/$IDEA_INSTALLATION_FILE | cut -d ' ' -f 1) \
     /tmp/$IDEA_INSTALLATION_FILE.sha256
mkdir -p ~/opt
tar -C ~/opt -x -f /tmp/$IDEA_INSTALLATION_FILE
mkdir -p ~/opt
find opt/ -name idea -exec ln -s ~/{} ~/.local/bin/idea \;

DBEAVER_VERSION=25.0.0
DBEAVER_INSTALLATION_FILE=dbeaver-ce-$DBEAVER_VERSION-linux.gtk.x86_64.tar.gz
curl -L -O --output-dir /tmp \
     https://dbeaver.io/files/$DBEAVER_VERSION/$DBEAVER_INSTALLATION_FILE
curl -L -O --output-dir /tmp \
     https://dbeaver.io/files/$DBEAVER_VERSION/checksum/$DBEAVER_INSTALLATION_FILE.sha256
grep $(sha256sum /tmp/$DBEAVER_INSTALLATION_FILE | cut -d ' ' -f 1) \
     /tmp/$DBEAVER_INSTALLATION_FILE.sha256
mkdir -p ~/opt
tar -C ~/opt -x -f /tmp/$DBEAVER_INSTALLATION_FILE
mkdir -p ~/opt
ln -s ~/opt/dbeaver/dbeaver ~/.local/bin/dbeaver
