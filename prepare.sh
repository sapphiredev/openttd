#!/bin/bash
set -e
source /tmp/buildconfig
set -x

## Temporarily disable dpkg fsync to make building faster.
if [[ ! -e /etc/dpkg/dpkg.cfg.d/docker-apt-speedup ]]; then
	echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup
fi

## Enable Ubuntu Universe and Multiverse.
#sed -i 's/^#\s*\(deb.*restricted\)$/\1/g' /etc/apt/sources.list
apt-get update
apt-get dist-upgrade -y -qq

## Install things we need
$minimal_apt_get_install wget unzip libfontconfig1 libfreetype6 liblzo2-2 libsdl1.2debian

## Install libicu55
wget -q https://launchpad.net/~ubuntu-security-proposed/+archive/ubuntu/ppa/+build/14502314/+files/libicu55_55.1-7ubuntu0.4_amd64.deb
dpkg -i libicu55_55.1-7ubuntu0.4_amd64.deb

## Create user
mkdir -p /home/openttd/.openttd
useradd -M -d /home/openttd -u 911 -U -s /bin/false openttd
usermod -G users openttd
chown openttd:openttd /home/openttd -R

## Download and install openttd
wget -q https://proxy.binaries.openttd.org/openttd-releases/${OPENTTD_VERSION}/openttd-${OPENTTD_VERSION}-linux-ubuntu-xenial-amd64.deb
dpkg -i openttd-${OPENTTD_VERSION}-linux-ubuntu-xenial-amd64.deb
mkdir -p /etc/service/openttd/

## Download GFX and install
mkdir -p /usr/share/games/openttd/baseset/
cd /usr/share/games/openttd/baseset/
#wget -q http://binaries.openttd.org/extra/opengfx/${OPENGFX_VERSION}/opengfx-${OPENGFX_VERSION}-all.zip
wget -q http://bundles.openttdcoop.org/opengfx/releases/${OPENGFX_VERSION}/opengfx-${OPENGFX_VERSION}.zip
unzip opengfx-${OPENGFX_VERSION}.zip
tar -xf opengfx-${OPENGFX_VERSION}.tar
rm -rf opengfx-*.tar opengfx-*.zip
