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
