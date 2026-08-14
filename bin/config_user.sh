#!/bin/sh
set -e

if [ $(id -u) -eq 0 ]; then
    echo "You should not be root"
    exit 1
fi

cp /etc/skel/.profile ~
cp /etc/skel/.bashrc ~

PATH="$HOME/.local/bin:$PATH"

echo '\nexport NO_AT_BRIDGE=1' >> ~/.profile

echo '\nexport GPG_TTY=$(tty)' >> ~/.profile

cat <<'EOF' >> ~/.profile

SSH_AGENT_ENV_FILE="$HOME/.ssh/agent-env"

if [ -z "$(pidof ssh-agent)" ]; then
    ssh-agent | head -n2 > $SSH_AGENT_ENV_FILE
fi
if [ -f $SSH_AGENT_ENV_FILE ]; then
    eval $(cat $SSH_AGENT_ENV_FILE)
fi
EOF
mkdir -p ~/.ssh
echo 'AddKeysToAgent yes' > ~/.ssh/config

rm -f ~/.local/share/containers/storage/libpod/bolt_state.db
mkdir -p ~/.config/containers
cat <<EOF > ~/.config/containers/storage.conf
[storage]
  driver = "overlay"

[storage.options]
  mount_program = "/usr/bin/fuse-overlayfs"
EOF

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

asdf plugin add helm-docs
asdf install helm-docs latest
asdf set -u helm-docs latest

asdf plugin add make
asdf install make latest
asdf set -u make latest

asdf plugin add shellcheck
asdf install shellcheck latest
asdf set -u shellcheck latest

asdf plugin add python
asdf install python 3.10.11
asdf set -u python 3.10.11


asdf plugin add azure-cli
asdf install azure-cli latest
asdf set -u azure-cli latest


asdf plugin add golang

asdf plugin add java
asdf install java temurin-jre-21.0.5+11.0.LTS
asdf set -u java temurin-jre-21.0.5+11.0.LTS

asdf plugin add maven
asdf install maven latest
asdf set -u maven latest

asdf plugin add gradle

asdf plugin add nodejs
asdf install nodejs 22.0.0
asdf set -u nodejs 22.0.0

asdf plugin add pnpm

asdf plugin add lua
asdf install lua latest
asdf set -u lua latest

IDEA_INSTALLATION_FILE=ideaIU-2024.3.3.tar.gz
curl -O --output-dir /tmp \
     "https://download-cdn.jetbrains.com/idea/$IDEA_INSTALLATION_FILE{,.sha256}"
grep $(sha256sum /tmp/$IDEA_INSTALLATION_FILE | cut -d ' ' -f 1) \
     /tmp/$IDEA_INSTALLATION_FILE.sha256
mkdir -p ~/opt
tar -C ~/opt -x -f /tmp/$IDEA_INSTALLATION_FILE
find opt/ -name idea -exec ln -s ~/{} ~/.local/bin/idea \;
asdf install nodejs 18.7.0
asdf set -u nodejs 18.7.0

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

VSCODE_VERSION=1.99.3
VSCODE_INSTALLATION_FILE=code-stable-$VSCODE_VERSION.tar.gz
curl -L -o /tmp/$VSCODE_INSTALLATION_FILE \
     "https://update.code.visualstudio.com/$VSCODE_VERSION/linux-x64/stable"
curl "https://update.code.visualstudio.com/api/versions/$VSCODE_VERSION/linux-x64/stable" |
    grep $(sha256sum /tmp/$VSCODE_INSTALLATION_FILE | cut -d ' ' -f 1)
mkdir -p ~/opt
tar -C ~/opt -x -f /tmp/$VSCODE_INSTALLATION_FILE
ln -s ~/opt/VSCode-linux-x64/code ~/.local/bin/code

gpg --recv-keys 019586D44BD80213
gpg --quick-lsign-key C08C18EE1706DB378BD993C8019586D44BD80213 plantuml@gmail.com
PLANTUML_VERSION=1.2025.3
PLANTUML_INSTALLATION_FILE=plantuml-$PLANTUML_VERSION.jar
mkdir -p ~/opt
curl -L -O --output-dir ~/opt \
     "https://github.com/plantuml/plantuml/releases/download/v$PLANTUML_VERSION/$PLANTUML_INSTALLATION_FILE{,.asc}"
gpg --verify ~/opt/$PLANTUML_INSTALLATION_FILE.asc
rm  ~/opt/$PLANTUML_INSTALLATION_FILE.asc
ln -fs ~/opt/$PLANTUML_INSTALLATION_FILE ~/opt/plantuml.jar

asdf plugin add pandoc
asdf install pandoc latest
asdf set -u pandoc latest
echo '\n. <(pandoc --bash-completion)' >> ~/.profile

echo docker.host=unix://${XDG_RUNTIME_DIR}/podman/podman.sock > $HOME/.testcontainers.properties
echo '\nexport TESTCONTAINERS_RYUK_DISABLED=true' >> ~/.profile

npm install -g @mermaid-js/mermaid-cli
asdf reshim

python -m pip install aider-install
asdf reshim
aider-install

asdf plugin add k6
