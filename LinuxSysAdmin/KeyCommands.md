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

### Partitioning

Command     | Description
------------|------------------------
`parted /dev/sdb` |


### XFS

Command     | Description
------------|------------------------
`xfs_info /dev/sdb1` |

### System Storage manager