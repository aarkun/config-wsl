#!/bin/sh
set -e

if [ "$(id -u)" -eq 0 ]; then
    echo 'You should not be root'
    exit 1
fi

echo 'Start user environment configuration'

cp /etc/skel/.profile ~
cp /etc/skel/.bashrc ~

PATH="$HOME/.local/bin:$PATH"

printf '\nexport NO_AT_BRIDGE=1\n' >> ~/.profile

printf '\nexport GPG_TTY=$(tty)\n' >> ~/.profile

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

mkdir -p ~/.local/bin
ln -fs "/mnt/c/Users/$USER/AppData/Local/Microsoft/WindowsApps/firefox.exe" \
   ~/.local/bin/firefox

mkdir -p ~/.emacs.d
curl -o ~/.emacs.d/init.el \
     https://raw.githubusercontent.com/aarkun/config-emacs/refs/heads/main/init.el

ASDF_VERSION=v0.16.4
ASDF_INSTALLATION_FILE=asdf-$ASDF_VERSION-linux-amd64.tar.gz
curl -L -O --output-dir /tmp \
     "https://github.com/asdf-vm/asdf/releases/download/$ASDF_VERSION/$ASDF_INSTALLATION_FILE{,.md5}"
grep "$(md5sum /tmp/$ASDF_INSTALLATION_FILE | cut -d ' ' -f 1)" \
     /tmp/$ASDF_INSTALLATION_FILE.md5
mkdir -p ~/.local/bin
tar -C ~/.local/bin -x -f /tmp/$ASDF_INSTALLATION_FILE
PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
printf '\nPATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"\n' >> ~/.profile
printf '\n. <(~/.local/bin/asdf completion bash)\n' >> ~/.bashrc
echo 'legacy_version_file = yes' > ~/.asdfrc

asdf plugin add direnv
asdf install direnv latest
asdf set -u direnv latest
printf '\neval "$(direnv hook bash)"\n' >> ~/.profile
mkdir -p ~/.config/direnv
printf '[global]\nload_dotenv = true\n' > ~/.config/direnv/direnv.toml

asdf plugin add kubectl
asdf install kubectl latest
asdf set -u kubectl latest
printf '\n. <(kubectl completion bash)\n' >> ~/.profile

asdf plugin add helm
asdf install helm 3.17.1
asdf set -u helm 3.17.1
printf '\n. <(helm completion bash)\n' >> ~/.profile

asdf plugin add helm-docs
asdf install helm-docs latest
asdf set -u helm-docs latest

helm plugin install https://github.com/dadav/helm-schema

asdf plugin add make
asdf install make latest
asdf set -u make latest

asdf plugin add shellcheck
asdf install shellcheck latest
asdf set -u shellcheck latest

asdf plugin add python
asdf install python 3.10.11
asdf set -u python 3.10.11

asdf plugin add uv
asdf install uv latest
asdf set -u uv latest

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
asdf install nodejs 22.22.0
asdf set -u nodejs 22.22.0

asdf plugin add pnpm

asdf plugin add lua
ASDF_LUA_LUAROCKS_VERSION=3.12.2 asdf install lua 5.4.7
asdf set -u lua 5.4.7

IDEA_INSTALLATION_FILE=ideaIU-2024.3.3.tar.gz
curl -O --output-dir /tmp \
     "https://download-cdn.jetbrains.com/idea/$IDEA_INSTALLATION_FILE{,.sha256}"
grep "$(sha256sum /tmp/$IDEA_INSTALLATION_FILE | cut -d ' ' -f 1)" \
     /tmp/$IDEA_INSTALLATION_FILE.sha256
mkdir -p ~/opt
tar -C ~/opt -x -f /tmp/$IDEA_INSTALLATION_FILE
find ~/opt -name idea -exec ln -sf {} ~/.local/bin/idea \;

DBEAVER_VERSION=25.1.0
DBEAVER_INSTALLATION_FILE=dbeaver-ce-$DBEAVER_VERSION-linux.gtk.x86_64-nojdk.tar.gz
curl -L -O --output-dir /tmp \
     https://github.com/dbeaver/dbeaver/releases/download/$DBEAVER_VERSION/$DBEAVER_INSTALLATION_FILE
printf '%s %s\n' \
       '069738a7a58d15d73a9f055e648e131c44f33837cd523d92a2e1203a10c54e49' \
       /tmp/$DBEAVER_INSTALLATION_FILE > /tmp/$DBEAVER_INSTALLATION_FILE.sha256
sha256sum -c /tmp/$DBEAVER_INSTALLATION_FILE.sha256
mkdir -p ~/opt
tar -C ~/opt -x -f /tmp/$DBEAVER_INSTALLATION_FILE
mkdir -p ~/.local/bin/
ln -fs ~/opt/dbeaver/dbeaver ~/.local/bin/dbeaver

VSCODE_VERSION=1.99.3
VSCODE_INSTALLATION_FILE=code-stable-$VSCODE_VERSION.tar.gz
curl -L -o /tmp/$VSCODE_INSTALLATION_FILE \
     "https://update.code.visualstudio.com/$VSCODE_VERSION/linux-x64/stable"
curl "https://update.code.visualstudio.com/api/versions/$VSCODE_VERSION/linux-x64/stable" |
    grep "$(sha256sum /tmp/$VSCODE_INSTALLATION_FILE | cut -d ' ' -f 1)"
mkdir -p ~/opt
tar -C ~/opt -x -f /tmp/$VSCODE_INSTALLATION_FILE
mkdir -p ~/.local/bin
ln -fs ~/opt/VSCode-linux-x64/code ~/.local/bin/code

gpg --recv-keys 019586D44BD80213
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
printf '\n. <(pandoc --bash-completion)\n' >> ~/.profile

echo docker.host="unix://${XDG_RUNTIME_DIR}/podman/podman.sock" \
     > "$HOME/.testcontainers.properties"
printf '\nexport TESTCONTAINERS_RYUK_DISABLED=true\n' >> ~/.profile

mkdir -p ~/opt
npm install -g --prefix ~/opt/mermaid @mermaid-js/mermaid-cli
mkdir -p ~/.local/bin
ln -fs ~/opt/mermaid/bin/mmdc ~/.local/bin/mmdc

mkdir -p ~/opt
UV_TOOL_DIR=~/opt uv tool install --python 3.12 aider-chat@latest

asdf plugin add k6

mkdir -p ~/opt
npm install -g --prefix ~/opt/opencode opencode-ai
mkdir -p ~/.local/bin
ln -fs ~/opt/opencode/bin/opencode ~/.local/bin/opencode

asdf plugin add trivy

mkdir -p ~/opt
npm install -g --prefix ~/opt/openspec @fission-ai/openspec@latest
mkdir -p ~/.local/bin
ln -fs ~/opt/openspec/bin/openspec ~/.local/bin/openspec

echo 'Finished user environment configuration'
