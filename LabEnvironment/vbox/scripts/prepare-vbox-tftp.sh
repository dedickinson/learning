#!/bin/bash -e

vbox_user_home=$1

rm -rf $vbox_user_home/TFTP/*

# Get PXE files from syslinux
mkdir -p .tmp-tftp
cd .tmp-tftp

if [ ! -e syslinux-6.03.tar.gz ]; then
    wget --no-clobber --output-document syslinux-6.03.tar.gz https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.gz
fi

rm -rf syslinux-6.03/
tar xzvf syslinux-6.03.tar.gz 
cp syslinux-6.03/bios/{core/pxelinux.0,com32/{menu/{menu,vesamenu}.c32,libutil/libutil.c32,elflink/ldlinux/ldlinux.c32,chain/chain.c32,lib/libcom32.c32}} $vbox_user_home/TFTP/
cd ..
# rm -rf .tmp-tftp

# Get ramdisk and kernel images
# NOTE: you must get the files for the version you intend to install (the version on the install media) 
#   - otherwise the installer will fail.

wget -P $vbox_user_home/TFTP/images/centos/7/ http://mirror.centos.org/centos/7/os/x86_64/images/pxeboot/{initrd.img,vmlinuz}
