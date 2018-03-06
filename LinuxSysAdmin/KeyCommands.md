# Key Commands

## TO ADD

- lspci
- lscpu

## Package management

Command     | Description
------------|------------------------
`yum whatprovides lsof` | Lists the package providing a file/app (e.g. `lsof`)

## SystemD management

### Services

Command     | Description
------------|------------------------
`systemctl start httpd`  | Start the service
`systemctl stop httpd`  | Stop the service
`systemctl enable httpd` | Enable the service to start at boot

### Run levels
Command     | Description
------------|------------------------


## Firewall

Command     | Description
------------|------------------------
`firewall-cmd --get-services` | Lists all pre-canned services known to the firewall

## DHCP

* Leases: `/var/lib/dhcpd/dhcpd.leases`

## Storage management

Handy commands:

- `lsof`: lists open files

### Mounting a filesystem

- `/mnt` is used for temporarily mounting
- `/mnt/cdrom` is usually a symbolic link

Command     | Description
------------|------------------------
`mount`                  | List all currently mounted filesystems
`mount /dev/cdrom /mnt/` | Mount the CD/DVD to `/mnt`
`umount /mnt`            | Unmounts the filesystem
`eject /dev/cdrom`       | Ejects (and unmounts) the CD/DVD

### fstab

XFS example:

    UUID=be9df528-6544-4592-99a8-b3a6d223ed3e /var/ftp/pub/distro     xfs     defaults        0 0

### Storage devices

Command     | Description
------------|------------------------
`lsblk`                 | Lists block devices
`parted /dev/sdb print` | Get the partition details for a device
`blkid -o list`         | Prints block device info, inc fs type and UUID
`shred -v /dev/sdb`     | Deletes the device

### Partitioning

Command     | Description
------------|------------------------
`parted /dev/sdb` | Starts the `parted` cli for the nominated device
cli: `print`      | Info about the device
cli: `mklabel gtp`| Sets the disk to use the GUID partition table
cli: `mkpart primary xfs 0% 25%` | Creates a primary partition with the `xfs` filesystem
cli: `rm 1` | Removes partition 1
cli: `quit` | Exits the `parted` cli



### XFS

Command     | Description
------------|------------------------
`xfs_info /dev/sdb1` |

### System Storage manager

Install:

    yum install system-storage-manager lvm2

Command     | Description
------------|------------------------
`ssm list ` | Lists info about detected devices, pools, volumes
`ssm create --fs xfs -s 5G -n centos-distro /dev/sdc1 /dev/sdc2` | Creates a new 5Gig logical volume in the default pool (`lvm_pool`). The pool has 2 physical volumes (`/dev/sdc1`, `/dev/sdc2`)
`ssm create --fs xfs -s 10G -n squid-cache`  | Creates a new logical volume in the default pool
`ssm mount /dev/lvm-pool/centos-distro /mnt` | Temporary mount of a logical volume

Example `/etc/fstab` entry:

    /dev/lvm_pool/centos-distro /var/ftp/pub/distro	  xfs	  defaults	  0 0