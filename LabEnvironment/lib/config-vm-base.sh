# The common baseline for VMs

VBoxManage createvm --name $BUILDER_VM --groups "/$VM_GROUP_NAME" --ostype RedHat_64 --register
VBoxManage modifyvm $BUILDER_VM --memory 512 --cpus 1 --audio none --usb off 
VBoxManage modifyvm $BUILDER_VM --biosbootmenu disabled --boot1 net --boot2 disk