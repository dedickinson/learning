# Attach the install DVD
VBoxManage storagectl $BUILDER_VM --add ide --name IDE
VBoxManage storageattach $BUILDER_VM --storagectl IDE --port 1 --device 0 --type dvddrive --medium "$VBOX_HOME/iso/CentOS-7-x86_64-Minimal-1708.iso"
