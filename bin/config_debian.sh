#!/bin/sh
set -e

echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/10get
sed /etc/apt/sources.list -e \
    's/\(deb.* \)main/\1non-free non-free-firmware/' \
    | tee /etc/apt/sources.list.d/debian.non-free.list
update-alternatives --set editor /usr/bin/vim.tiny
sed -iorig -e 's/# de_DE\.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen

apt-get update

apt-get install -y dbus-user-session

apt-get install -y \
	aspell-de \
	bash-completion \
	btop \
	ca-certificates \
	curl \
	dos2unix \
	emacs \
	emacs-common-non-dfsg \
	file \
	git \
	gitk \
	gnupg \
	gnuplot \
	htop \
	lsof \
	man-db \
	net-tools \
	netcat-openbsd \
	markdown \
	openssh-client \
	patch \
	telnet \
	xorriso \
	xz-utils

apt-get install -y \
	auctex \
	texlive-latex-recommended \
	texlive-latex-extra \
	texlive-plain-generic

apt-get purge -y \
	*docker* \
	docker-compose \
	*container* \
	*podman* \
	podman-compose
apt-get autopurge -y

rm -rf /var/lib/docker \
   /var/lib/containerd \
   /etc/apt/sources.list.d/docker.list \
   /etc/apt/keyrings/docker.asc \
   /etc/containers
apt-get install -y podman
apt-get install -y --mark-auto \
	uidmap \
	slirp4netns \
	aardvark-dns
apt-get install -y --mark-auto fuse-overlayfs
apt-get install -y podman-compose

curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
    | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
    | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
    | tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
apt-get update
apt-get install -y nvidia-container-toolkit
nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml

apt-get install -y \
	gcc \
	zlib1g-dev \
	libssl-dev

apt-get install -y unzip

apt-get install -y \
	libxtst6 \
	libgbm1 libglx-mesa0

apt-get install -y \
	libgl1

apt-get install -y graphviz
