#!/bin/sh
set -xe

OS_VER=${1:-buster}

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

ZPOOL_NAME=tank
ZPOOL_BACKING_FILE=/tank-zpool-backing-file
ZFS_NAME=root
ROOT_DIR=/$ZPOOL_NAME/$ZFS_NAME

echo creating zpool $ZPOOL_NAME backed by $ZPOOL_BACKING_FILE with an fs at $ROOT_DIR...
create_zpool_and_root_zfs $ZPOOL_NAME $ZPOOL_BACKING_FILE $ZFS_NAME

echo configuring chroot at $ROOT_DIR...
cp chroot-entry.sh $ROOT_DIR/chroot-entry.sh
cp debootstrap-lib.sh $ROOT_DIR/debootstrap-lib.sh
/usr/sbin/debootstrap --arch amd64 $OS_VER $ROOT_DIR http://ftp.us.debian.org/debian/
mount -t proc /proc $ROOT_DIR/proc/
mount -t sysfs /sys $ROOT_DIR/sys/
mount -o bind /dev $ROOT_DIR/dev/
echo chroots away...
chroot $ROOT_DIR /chroot-entry.sh
echo done: $(date)
