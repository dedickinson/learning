#!/bin/bash -e
# Attach the install DVD

vm_name=$1
iso_path=$2

VBoxManage storagectl $vm_name --add ide --name IDE
VBoxManage storageattach $vm_name --storagectl IDE --port 1 --device 0 --type dvddrive \
    --medium "$2"
