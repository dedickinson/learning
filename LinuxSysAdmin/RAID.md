# RAID devices

Software RAID used to create fault tolerance and provide performance

Levels:

* linear - spans storage over different sized disks

* Raid 0 same as linear but same size disks

* Raid 1 mirror over 2 disks

* Raid 4-6 data is striped with parity over 3 or more disks

Check raid support

    cat /proc/mdstat

Install 

    yum install mdadm

Check the Kernel module:

    lsmod | grep raid

Configure 

    # Create a 2-disk mirror (RAID 1)
    mdadm --create /dev/md0 --verbose --level=mirror --raid-devices=2 /dev/sdb13 /dev/sdb14
    mkfs.xfs /dev/md0

    # Create a RAID 5 array with three disks
    mdadm --create /dev/md1 --level 5 --raid-devices=3 /dev/sdb10 /dev/sdb9 /dev/sdb8
    mkfs.xfs /dev/md1
    
    # Add a spare device 
    mdadm --manage /dev/md1 --add-spare /dev/sdb7
    mdadm --detail /dev/md1

    # configure for assembly at reboot
    mdadm --detail --scan >> /etc/mdadm.conf

Drop a disk out of the RAID 5:

    mdadm --manage /dev/md1 --replace /dev/sdb9
    
    # And check the change (sdb9 is marked as faulty once swapped out):
    mdadm --detail /dev/md1
    
    # Add sdb9 back as the spare:
    mdadm --manage /dev/md1 --re-add /dev/sdb9

To stop an array

    mdadm --stop /dev/md0

To start

    mdadm --assemble --scan

To add to `fstab`:

    /dev/md1 /data xfs defaults 0 0