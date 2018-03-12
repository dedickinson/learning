# NFS

## Install and Configure

    yum install nfs-utils

    firewall-cmd --add-service=nfs --permanent
    firewall-cmd --reload

    systemctl enable nfs-server rpcbind
    systemctl start nfs-server rpcbind

## Setup a share

Setup a mountpoint:

    mkdir /share/nfs

Add into `/etc/exports`

    /share/nfs *(ro)

Then run

    exportfs -r
    
To list the exports:

    exportfs -s

## Mount an NFS share

### Quick mount

On another server

    yum install nfs-utils
    
    mount -t nfs server2.example.com:/share/nfs /mnt

    ls /mnt
    mount # just to review
    umount /mnt

### Permanent mount

In `/etc/fstab`:

  server1.lab.example.com:/share/nfs /mnt nfs ro

### Auto mount

Install `autofs`

  yum install autofs
  systemctl enable autofs
  systemctl start autofs

Open `/etc/auto.misc` and add

  nfsshare        -ro,soft,intr           server1.lab.example.com:/share/nfs

Then:

    systemctl restart autofs

    cd /misc/nfsshare
    ls

    ls /misc/shar
