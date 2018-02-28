# System Storage Manager

- [RHEL 7 Storage Admin Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/storage_administration_guide/ch-ssm)

## Install

    yum install system-storage-manager lvm2

## The basics

To list devices:

    ssm list
    
# Create a New Pool, Logical Volume, and File System:

    ssm create --fstype xfs --size 1G --name lv1 --pool  /dev/sdb /dev/vdc
