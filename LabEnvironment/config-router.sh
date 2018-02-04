#!/bin/bash -e

# Configures a Router VM that is:
# 1. The Gateway for the lab network (via a NAT interface)
# 2. Provides an internal PXE boot service for the lab servers
# 3. 

source lib/set-vars.sh
source lib/check-vm-not-exists.sh
source lib/check-http.sh
source lib/prep-tftp.sh
source lib/prep-dirs.sh

# Create the VM
source lib/config-vm-base.sh

# The first network interface is NAT'ed and uses VirtualBox's PXE
# boot service for startup
VBoxManage modifyvm $BUILDER_VM --nic1 nat --nicbootprio1 1
VBoxManage modifyvm $BUILDER_VM --nattftpfile1 pxelinux.0

# The Hostonly interface is used to provide access from the Host VM
# Primarily to let it run as a bastion box.
VBoxManage modifyvm $BUILDER_VM --nic2 hostonly
VBoxManage modifyvm $BUILDER_VM --hostonlyadapter2 vboxnet0

# The Internal network is the one that host the Lab environment (labnetwork)
VBoxManage modifyvm $BUILDER_VM --nic3 intnet 
VBoxManage modifyvm $BUILDER_VM --intnet3 labnetwork-internal

VBoxManage modifyvm $BUILDER_VM --nic4 intnet 
VBoxManage modifyvm $BUILDER_VM --intnet4 labnetwork-dmz

VBoxManage modifyvm $BUILDER_VM --nic5 intnet 
VBoxManage modifyvm $BUILDER_VM --intnet5 labnetwork-external

source lib/attach-hdd.sh
source lib/attach-installdvd.sh
