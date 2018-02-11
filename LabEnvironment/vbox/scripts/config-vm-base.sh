#!/bin/bash -e

vm_name=$1
vm_group_name=$2

vm_exists=$(VBoxManage list vms | grep "$vm_name" | cut -f 1 -d " "| tr -d '"')

if [ "$vm_exists" == "" ]; then
    VBoxManage createvm --name $vm_name --groups "/$vm_group_name" --ostype RedHat_64 --register
fi

VBoxManage modifyvm $vm_name --memory 512 --cpus 1 --audio none --usb off 
VBoxManage modifyvm $vm_name --biosbootmenu disabled --boot1 net --boot2 disk