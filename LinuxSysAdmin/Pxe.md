# PXE

The Pre-boot eXecution Environment:

- Syslinux: boot from FAT filesystems
- Pxelinux: Network booting
- ISOLinux: Bootable CD/DVD
- ExtLinux: Boot from ext or btrfs filesystems

## Install

On the PXE host:

    yum install syslinux tftp tftp-server

## Configure DHCP and TFTP

    vim /etc/dhcp/dhcp.conf

in the subnet config, add

    next-server <ip of pxe server>;
    filename “pxelinux.0”;

Then test the config

    dhcpd -t -cf /etc/dhcp/dhcp.conf

And restart

    systemctl restart dhcpd

    netstat -lun #look for bootp

Tftp root dir: /var/lib/tftpboot

    cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/

    cp /usr/share/syslinux/menu.c32 /var/lib/tftpboot/
    
Copy the vmlinuz and initrd.img file from the install ISO

Start the tftp server

    systemctl start tftp.socket
    systemctl enable tftp.socket

## Default PXE options

    cd /var/lib/tftpboot

    mkdir pxelinux.cfg

    cd pxelinux.cfg

    vim default

Configure `default` as follows:

    default menu.32
    prompt 0
    timeout  1000
    ontimeout local

    menu title Boot menu
 
    label local
        menu Boot from local disk
        LOCALBOOT 0

Don’t need to restart service.

## MAC Specific config

Can use UUID or MAC 

In pxelinux.cfg/, copy default to a file named 01-<macaddr>.

Add a new menu item

    label install
        menu Manual install
        kernel vmlinuz
        append initrd=initrd.img ip=dhcp repo=ftp://<ip>/pub/centos

## Kickstart

Answer files are in /root/anaconda-ks.cfg. Copy to /var/ftp/pub/install.ks and edit as needed.

    label install
        menu Manual install
        kernel vmlinuz
        append initrd=initrd.img ip=dhcp repo=ftp://<ip>/pub/install.ks



