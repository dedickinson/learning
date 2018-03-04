# Partitioning a disk

## Linux file system overview

Partition types:

* `msdos`: Within the disk is an MBR partition table (max 2Tb) with max 4 primary partitions and up to 15 logical partitions on one primary partition. 
* `gtp`: a GUID partition of up to 8ZB that can have up to 128 partitions. Linux SCSI drivers limit this to 15.

On top of the partitions is a file system such as `xfs` or `ext4`

Three partitioning tools: `fdisk`, `gdisk`, `parted`

## To clear a drive or partition

To format a partition, unmount it and then:

    mkfs.xfs -f /dev/sdb1

To clear an existing device (not a partition):

    shred -v /dev/sdb

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

### Mount an ISO and copy to the new mount

    mount /dev/cdrom /mnt/
    
    mkdir -p /var/ftp/pub/distro/centos/7

    cd /mnt
    find . | cpio -pmd /var/ftp/pub/distro/centos/7
    

## Create a Logical Volume

Start the `parted` CLI for the desired device:

    parted /dev/sdc

In the CLI:

    mklabel gpt
    mkpart primary 0% 25%
    mkpart primary 25% 50%
    mkpart primary 50% 75%
    mkpart primary 75% 100%
    print
    quit

Install System Storage Manager

    yum install system-storage-manager lvm2

Then use `ssm` to configure the logical volume.

    ssm list
    ssm create --fs xfs -s 5G -n centos-distro /dev/sdc1 /dev/sdc2

    # Example of adding more capacity
    ssm add /dev/sdc3
    ssm add /dev/sdc4

    # Create a new logical volume
    ssm create --fs xfs -s 10G -n squid-cache

Configure `/etc/fstab`:

    /dev/lvm_pool/centos-distro /var/ftp/pub/distro     xfs     defaults        0 0
    /dev/lvm_pool/squid-cache /var/spool/squid          xfs     defaults        0 0

