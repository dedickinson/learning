# The common baseline for VMs

vm_name=$1

VBoxManage createvm --name $vm_name --groups "/$VM_GROUP_NAME" --ostype RedHat_64 --register
VBoxManage modifyvm $vm_name --memory 512 --cpus 1 --audio none --usb off 
VBoxManage modifyvm $vm_name --biosbootmenu disabled --boot1 net --boot2 disk