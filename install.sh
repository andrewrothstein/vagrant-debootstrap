#!/bin/sh
set -xe

OS_VER=${1:-buster}
ROOT_DIR=${2:-/mnt}

. ./debootstrap-lib.sh

apt_not_interactive
add_apt_sources
install_debootstrap

echo installing zfs...
add_zfs_prefs
install_zfs

echo probing for zfs kernel module...
udevadm trigger
modprobe zfs

echo configuring chroot...
mkdir -p $ROOT_DIR
cp chroot-entry.sh $ROOT_DIR/chroot-entry.sh
cp debootstrap-lib.sh $ROOT_DIR/debootstrap-lib.sh
/usr/sbin/debootstrap --arch amd64 $OS_VER $ROOT_DIR http://ftp.us.debian.org/debian/
mount -t proc /proc $ROOT_DIR/proc/
mount -t sysfs /sys $ROOT_DIR/sys/
mount -o bind /dev $ROOT_DIR/dev/
echo chroots away...
chroot $ROOT_DIR /chroot-entry.sh
echo done: $(date)
