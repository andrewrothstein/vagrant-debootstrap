
add_apt_sources () {
    echo adding buster contrib apt source...
    cat > /etc/apt/sources.list.d/buster-contrib.list <<EOF
deb http://deb.debian.org/debian buster contrib
EOF

    echo adding buster-backports apt source...
    cat > /etc/apt/sources.list.d/buster-backports.list <<EOF
deb http://deb.debian.org/debian ${OS_VER}-backports main contrib
deb-src http://deb.debian.org/debian ${OS_VER}-backports main contrib
EOF

    apt update
}

add_zfs_prefs () {
    cat > /etc/apt/preferences.d/90_zfs <<EOF
Package: libnvpair1linux libuutil1linux libzfs2linux libzpool2linux spl-dkms zfs-dkms zfs-test zfsutils-linux zfsutils-linux-dev zfs-zed
Pin: release n=${OS_VER}-backports
Pin-Priority: 990
EOF
}

install_debootstrap () {
    apt install -y debootstrap
}

install_zfs () {
    apt install -y gdisk dpkg-dev linux-headers-amd64 htop nethogs
    apt install -y dkms spl-dkms
    apt install -y zfs-dkms zfsutils-linux
}

install_cloud_init () {
    apt install -y cloud-init
}

apt_not_interactive () {
    export DEBIAN_FRONTEND=noninteractive
}

create_zpool_and_root_zfs () {
    local zpool_name=$1
    local zpool_backing_file=$2
    local zfs_name=$3
    local bs=1M
    local count=8096
    dd if=/dev/zero of=$zpool_backing_file bs=$bs count=$count
    zpool create $zpool_name $zpool_backing_file
    zfs create $zpool_name/$zfs_name
}
