#!/bin/sh
set -e

echo 'Start Debian configuration'

echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/10get
sed /etc/apt/sources.list -e \
    's/\(deb.* \)main/\1non-free non-free-firmware/' \
    > /etc/apt/sources.list.d/debian.non-free.list
apt-get update

find /etc/apt -name '*.list' -a ! -name '*nvidia*' -exec sed -i -e 's/stable/bookworm/g' {} \;
apt-get update && \
    apt-get dist-upgrade --purge -y
find /etc/ -regex '.*\.dpkg-\(old\|new\)' -delete
installed_packages="$(mktemp)"
dpkg-query -W -f '${db:Status-Abbrev}\t${Package}\n' | grep '^.[^nc]' | cut -f2 | sort > "$installed_packages"

unavailable_packages="$(mktemp)"
apt-cache dumpavail | sed -rn 's/^Package: (.*)/\1/p' | sort -u > "$unavailable_packages"

comm -23 "$installed_packages" "$unavailable_packages" | xargs apt-get purge -y

rm "$installed_packages"
rm "$unavailable_packages"

unset installed_packages
unset unavailable_packages
find /etc/apt -name '*.list' -exec sed -i -e 's/bookworm/trixie/g' {} \;
apt-get update && \
    apt-get dist-upgrade --purge -y
find /etc/ -regex '.*\.dpkg-\(old\|new\)' -delete
installed_packages="$(mktemp)"
dpkg-query -W -f '${db:Status-Abbrev}\t${Package}\n' | grep '^.[^nc]' | cut -f2 | sort > "$installed_packages"

unavailable_packages="$(mktemp)"
apt-cache dumpavail | sed -rn 's/^Package: (.*)/\1/p' | sort -u > "$unavailable_packages"

comm -23 "$installed_packages" "$unavailable_packages" | xargs apt-get purge -y

rm "$installed_packages"
rm "$unavailable_packages"

unset installed_packages
unset unavailable_packages

update-alternatives --set editor /usr/bin/vim.tiny

sed -i -e 's/# de_DE\.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen

apt-get install -y linux-image-amd64

apt-get install -y dbus-user-session

apt-get autopurge -y \
	'*docker*' \
	docker-compose \
	'*container*' \
	'*podman*' \
	podman-compose

rm -rf /var/lib/docker \
   /var/lib/containerd \
   /etc/apt/sources.list.d/docker.list \
   /etc/apt/keyrings/docker.asc \
   /etc/containers
apt-get install -y --mark-auto \
	aardvark-dns \
	ca-certificates \
	dbus-user-session
apt-get install -y podman
apt-get install -y --mark-auto \
	uidmap \
	passt
apt-get install -y podman-compose

apt-get install -y --mark-auto curl
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
    | gpg --yes --dearmor \
	  -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
    | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
    > /etc/apt/sources.list.d/nvidia-container-toolkit.list
apt-get update
apt-get install -y nvidia-container-toolkit
nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml

apt-get install -y gnupg
apt-get install -y pinentry-fltk

apt-get install -y \
	git \
	gitk \

apt-get install -y \
	emacs \
	emacs-common-non-dfsg \

apt-get install -y \
  	aspell-de \

apt-get install -y \
	auctex \
	texlive-latex-recommended \
	texlive-latex-extra \
	texlive-plain-generic

apt-get install -y \
	bash-completion \
	btop \
	curl \
	dos2unix \
	file \
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
	gcc \
	zlib1g-dev \
	libssl-dev

apt-get install -y unzip

apt-get install -y \
	libgbm1 \
	libgl1 \
	libnss3

apt-get install -y \
	libgl1 \
	libnss3

apt-get install -y graphviz

echo 'Finished Debian configuration'
