# iSCSI block storage server

- iSCSI _targets_ are servers that share out block devices
- iSCSI _initiators_ are clients

## Storage server

### Install

Install the required packages:

    yum install targetd targetcli

    systemctl enable targetd

_Note:_ don’t need to start service - the kernel does it automatically

Configure the firewall:

    firewall-cmd --add-service=iscsi-target --permanent

    firewall-cmd --reload


### Share out LVMs

Prepare a logical volume without a filesystem:

    ssm create -s 1G -n mediashare -p lvm_pool

Configure target (server) using the `targetcli`

In the CLI:

    backstores/block create mediashare /dev/lvm_pool/mediashare

    iscsi/ create iqn.2018-03.com.example.lab.router:media

    cd iscsi/iqn.2018-03.com.example.lab.router:media/tpg1/

    luns/ create /backstores/block/mediashare

    acls/ create iqn.2018-03.com.example.lab.canaryinternal:media

    cd /

    ls

    saveconfig
    exit

The last `ls` will present something like:

````
o- / ............................................................................................................. [...]
  o- backstores .................................................................................................. [...]
  | o- block ...................................................................................... [Storage Objects: 1]
  | | o- mediashare ........................................... [/dev/lvm_pool/mediashare (1.0GiB) write-thru activated]
  | |   o- alua ....................................................................................... [ALUA Groups: 1]
  | |     o- default_tg_pt_gp ........................................................... [ALUA state: Active/optimized]
  | o- fileio ..................................................................................... [Storage Objects: 0]
  | o- pscsi ...................................................................................... [Storage Objects: 0]
  | o- ramdisk .................................................................................... [Storage Objects: 0]
  o- iscsi ................................................................................................ [Targets: 1]
  | o- iqn.2018-03.com.example.lab.router:media .............................................................. [TPGs: 1]
  |   o- tpg1 ................................................................................... [no-gen-acls, no-auth]
  |     o- acls .............................................................................................. [ACLs: 1]
  |     | o- iqn.2018-03.com.example.lab.canaryinternal:media ......................................... [Mapped LUNs: 1]
  |     |   o- mapped_lun0 ................................................................ [lun0 block/mediashare (rw)]
  |     o- luns .............................................................................................. [LUNs: 1]
  |     | o- lun0 ..................................... [block/mediashare (/dev/lvm_pool/mediashare) (default_tg_pt_gp)]
  |     o- portals ........................................................................................ [Portals: 1]
  |       o- 0.0.0.0:3260 ......................................................................................... [OK]
  o- loopback ............................................................................................. [Targets: 0]
````

This writes the config.

## Configure iSCSI initiator (client)

On the client

    yum install iscsi-initiator-utils

Edit the client name:

    vi /etc/iscsi/initiatorname.iscsi

Set the name as per the ACL in the server.

    InitiatorName=iqn.2018-03.com.example.lab.canaryinternal:media

Look at the target portal:

    iscsiadm -m discovery -t st -p 172.16.1.1

Connect:

    iscsiadm -m node -T iqn.2018-03.com.example.lab.router:media -l 

    lsblk # target not listed yet

    iscsiadm --mode node --targetname iqn.2018-03.com.example.lab.router:media -l

    lsblk # can see it now, maybe sdc









