# Create a hard drive for a VM and attach it

VBoxManage createmedium disk --filename "$VBOX_HOME/lab/disk/$BUILDER_VM" --size 8192 --format VDI 
VBoxManage storagectl $BUILDER_VM --add sata --name SATA --controller IntelAhci --portcount 1 --bootable on
VBoxManage storageattach $BUILDER_VM --storagectl SATA --port 0 --type hdd --medium "$VBOX_HOME/lab/disk/$BUILDER_VM.vdi"
