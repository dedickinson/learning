#!/bin/bash -e
# Attach the install DVD

vm_name=$1
iso_path=$2

if ($(VBoxManage showvminfo $vm_name|grep $iso_path|wc -l) == 0 ); then
    VBoxManage storagectl $vm_name --add ide --name IDE
    VBoxManage storageattach $vm_name --storagectl IDE --port 1 --device 0 --type dvddrive \
        --medium "$iso_path"
fi
