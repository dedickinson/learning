# Virtualisation 

## KVM

Run `lscpu` to check on hardware

    lscpu

    cat /proc/cpuinfo

Look for “vmx” or “svm”. Also need to look at the BIOS for your motherboard.

Check that time is accurate

    ntpq -p

    cat /etc/ntp.conf

## XRDP

XRDP is the Remote Desktop protocol for X. Runs on port 3389.

The actual connection is via an internal VNC service on 5901.

Install from epel:

    yum install xrdp

Side note - roll back an install:
    yum history info
    yum history undo <n>

### Configure

Config is in /etc/xrdp

Enable with selinux:

    getenforce # make sure is enforcing

    cd /usr/sbin

    ls -Z xrdp*

    chcon -t bin_t xrdp xrdp-sesman

    systemctl start xrdp
    systemctl enable xrdp

    netstat -ltn # look for 3389

Then configure:

    cd /etc/xrdp
    vi startwm.sh

After the locale if block

    echo 'mate-session' > ~/.xsession
    chmod +x ~/?xsession

### Set keymap files

In the remote session:

    cd /etc/xrdp

    setxkbmap -layout gp
    xrdp-genkeymap km-0809.ini #UK

Then disconnect from RDP session and reconnect.

## VM Networking

Libvirt is used to manage virtual networks for KVM.

virbr0 is installed by libvirt as the bridge for virtualised systems.

### Install libvirt

    yum install libvirt

    ip a # No virtual networking yet

    cd /etc/libvirt/qemu/networks/
    cat default.xml

    systemctl start libvirtd
    systemctl enable libvirtd

    ip a # now virbr0 displays

    brctl show

    ls /etc/sysconfig/network-scripts # no listing for virtual networks

### Using virsh

    virsh list

    virsh net-list

    cd /etc/libvirt/qemu/networks/
    cat default.xml

    ls autostart # list the auto starting components

    virsh # open an interactive session

Using virsh

    net-destroy default #really just stops

    net-list

    net-list —inactive

    # stop default from starting
    # removes link from autostart
    net-autostart —disable default

To completely remove the network

    virsh net-destroy default
    cp default.xml ~/

    virsh net-undefine default

To create a network

    cd /etc/libvirt/qemu/networks/
    cp ~/default.xml .

    virsh net-define default.xml
    virsh net-list —inactive

    virsh net-start default
    virsh net-autostart default
    
    virsh net-edit default

An editor is now opened for editing the network. Make changes, such as network address and range. Save and then:

    virsh net-destroy default
    virsh net-start default

    ip a s virbr0

Create a host-only if. Copy default to hostonly.xml. Remove the UUID, and the forward mode. Create a new bridge by setting name to virbr1. Change the MAC. Change the IP address and the address range.

    virsh net-define hostonly.xml
    virsh net-start hostonly
    virsh net-autostart hostonly
    virsh net-list

The ‘brctl’ tool is an older method for managing network bridges.

## Installing KVM

Kernel-based virtual machine. Two kernel modules: kvm.ko and either kvm-intel.ko or kvm-amd.ko

    yum install qemu-kvm virt-install

To install GUI manager, add 'virt-manager'

Then check the kernel module

    lsmod | grep kvm

## Connect with virsh

Connect locally using 

    virsh
    # or, equivalently
    virsh -c qemu:///system

To connect from a remote host, install libvirt on that system and

    virsh -c qemu+ssh://root@<ip>/system

Swap root with a user who has enough perms.

Use virt-manager as a control UI.

## Create a guest VM

Used virt-manager GUI to start the VM

### PXE boots

On the host, install vsftp and place iso and kickstart there.

Setup the tftp folder but you don’t need the service

Then

    virsh net-edit default

Within the ip element, add in

    <tftp root='/tftpboot'/>

In the dhcp element, add in

    <bootp file='pxelinux.0'/>

Restart the default network

Check selinux permissions if can’t access tftpboot:

    grep dnsmasq /var/log/audit/audit.log | audit2allow -M mypol

    semodule -i mypol.pp

### CLI VM creation

    virsh list
    virsh list —all

    yum install virt-install virt-viewer

    virt-install —name testvm —hvm —network=bridge:virbr0 —pxe —graphics spice —ram=728 —vcpus=1 —os-type=Linux —os-variant=rhel7 —disk path=/var/lib/libvirt/images/c7-auto.qcow2,size=9

## Managing VMs

### Configure a lab environment

Add a static host:

    virsh net-update default add ip-dhcp-host “<host mac='52:54:<rest-of-macaddr>' name='demo1' ip='192.168.56.11'/>” —live —config

In the pxe tftp boot dir, /tftpboot/pxelinux.cfg/, create files based on the MAC address. E.g.

     /tftpboot/pxelinux.cfg/01-52-54-00-00-00-01

These can point to specific kickstart files.

Create a vm

    virt-install —name lab1 —hvm —network=bridge:virbr0,mac=52:54:00:00:00:01 —pxe —graphics spice —ram=728 —vcpus=1 —os-type=Linux —os-variant=rhel7 —disk path=/var/lib/libvirt/images/lab1.qcow2,size=9

### Manage vm status

Can use the GUI

Open virsh cli

    destroy lab1
    start lab1

    reboot lab1

    list

    list —all

    undefine lab6 —remove-all-storage

To monitor

GUI preferences set which stats to monitor.

For the CLI

    yum install virt-top

### Config VM Resources

Note, VM disks can be /dev/vda 

In virsh

    dominfo lab1

    autostart lab1

    autostart lab1 —disable

    shutdown lab1

    setmaxmem lab1 1500M —config

    dominfo lab1

Can change some config when vm is running

    setmem lab1 728M —live

### Cloning and snapshots

Need to power off a vm to clone it. Clones are tricky as the OS often needs re-config.

### VM migrations

- Setup shared NFS to store disk files
- setup 2 kvm hosts
- setup 1 VM and move between hosts

NFS: edit /etc/exports to share a dir with a network, then

    exportfs

Setup shared storage in virtual machine manager. For each kvm host, add storage. The mount point must be the same on both hosts. In the NFS storage config, add a volume (the disk being used).

On the second kvm host, connect to the nfs share and you should see the volume just created.

Make sure networks are the same on both hosts.

Create a new vm using the disk in nfs. Start the vm.

In the new vm, disable the virtual disk cache so data isn’t lost on migration.

Right-click on the VM and click migrate.




