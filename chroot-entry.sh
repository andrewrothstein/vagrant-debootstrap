#!/bin/sh
set -xe

OS_VER=${1:-buster}

. ./debootstrap-lib.sh

apt_not_interactive
add_apt_sources
add_zfs_prefs
install_zfs

