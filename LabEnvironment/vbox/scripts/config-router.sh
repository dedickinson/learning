#!/bin/bash -e

vm_name=$1

# The first network interface is NAT'ed and uses VirtualBox's PXE
# boot service for startup
VBoxManage modifyvm $vm_name --nic1 nat --nicbootprio1 1
VBoxManage modifyvm $vm_name --nattftpfile1 pxelinux.0

# The Hostonly interface is used to provide access from the Host VM
# Primarily to let it run as a bastion box.
VBoxManage modifyvm $vm_name --nic2 hostonly
VBoxManage modifyvm $vm_name --hostonlyadapter2 vboxnet0

VBoxManage modifyvm $vm_name --nic3 bridged
VBoxManage modifyvm $vm_name --bridgeadapter3  en4

# The Internal network is the one that host the Lab environment (labnetwork)
VBoxManage modifyvm $vm_name --nic4 intnet 
VBoxManage modifyvm $vm_name --intnet4 labnetwork-internal
#VBoxManage modifyvm $vm_name --cableconnected3 off

VBoxManage modifyvm $vm_name --nic5 intnet 
VBoxManage modifyvm $vm_name --intnet5 labnetwork-dmz
#VBoxManage modifyvm $vm_name --cableconnected4 off

VBoxManage modifyvm $vm_name --nic6 intnet 
VBoxManage modifyvm $vm_name --intnet6 labnetwork-external
#VBoxManage modifyvm $vm_name --cableconnected5 off
