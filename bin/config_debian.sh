#!/bin/sh
set -e

echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/10get
