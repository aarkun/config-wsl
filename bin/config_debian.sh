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
apt-get install -y \
	aspell-de \
	bash-completion \
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
	man-db \
	net-tools \
	netcat-openbsd \
	markdown \
	openssh-client \
	patch
apt-get install -y \
	auctex \
	texlive-latex-recommended \
	texlive-latex-extra \
	texlive-plain-generic

apt-get purge -y \
	docker \
	docker-compose \
	containernetworking-plugins \
	podman \
	podman-compose
apt-get autopurge -y
apt-get install -y podman
apt-get install --mark-auto \
	uidmap \
	slirp4netns
apt-get install -y podman-compose

apt-get install -y \
	gcc \
	zlib1g-dev \
	libssl-dev
