#!/bin/bash -e
# Create a hard drive for a VM and attach it

vm_name=$1
disk_path=$2

VBoxManage createmedium disk --filename "$disk_path/$vm_name" --size 8192 --format VDI 
VBoxManage storagectl $vm_name --add sata --name SATA --controller IntelAhci --portcount 1 --bootable on
VBoxManage storageattach $vm_name --storagectl SATA --port 0 --type hdd --medium "$disk_path/$vm_name.vdi"
