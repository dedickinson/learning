VBOX_USER_HOME=$HOME/Library/VirtualBox
BUILDER_VM=${1-builder}
VM_GROUP_NAME="lab"
VBOX_HOME=$HOME/VirtualBox\ VMs

vm_exists=`VBoxManage list vms | grep '"bastion"' | cut -f 1 -d " "`
http_ps=$(lsof -i -P -n | grep "TCP \*:8000 (LISTEN)"|cut -c 11-14)
