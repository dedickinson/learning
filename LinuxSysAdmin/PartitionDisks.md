# Partitioning a disk

## A basic single partition approach

In Virtual Box, create a new disk - say 20Gb - and attach it to a VM. Then start the VM
and follow along from the command line.

Check the block devices:

    lsblk

Get the device/partition details (assuming new disk is on `/dev/sdb`):

    parted /dev/sdb print

Enter the `parted` cli:

    parted /dev/sdb

Then run these commands to create a GUID partition that takes up the whole disk:

    mklabel gpt

    mkpart primary xfs 1 100%

    print

    quit

Then create the filesystem

    mkfs.xfs /dev/sdb1

Alternatively, use `mkpartfs` in `parted` and the filesystem is created once the partition has been setup

Edit the filesystem by running `xfs_db -x /dev/sdb1` and setting the label

    label distro

Create a directory to mount to:

    mkdir -p /var/ftp/pub/distro

Check the UUID of the partition:

    xfs_db -x /dev/sdb1 -c uuid

    # or

    blkid -o list

Add a line to `/etc/fstab`:

    UUID=be9df528-6544-4592-99a8-b3a6d223ed3e /var/ftp/pub/distro     xfs     defaults        0 0

Get some info:

    xfs_info /dev/sdb1

## Mount an ISO and copy to the new mount

    mount /dev/cdrom /mnt/
    
    mkdir -p /var/ftp/pub/distro/centos/7

    cd /mnt
    find . | cpio -pmd /var/ftp/pub/distro/centos/7
    
