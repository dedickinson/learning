# PXE-based kickstart in VirtualBox

References:

* The following gist really helped out on this: https://gist.github.com/jtyr/816e46c2c5d9345bd6c9
* [VirtualBox - Global Configuration Data](https://www.virtualbox.org/manual/ch10.html#idp47569015460640) - check this out to determine where `VBOX_USER_HOME` is configured

## Create a PXE Boot environment

Setup the TFTP folders:

````
export VBOX_USER_HOME=$HOME/Library/VirtualBox
export BUILDER_VM=builder
export VBOX_HOME=$HOME/VirtualBox\ VMs
mkdir -p $VBOX_USER_HOME/TFTP/{pxelinux.cfg,images/centos/7}
cp -R tftp/* $VBOX_USER_HOME/TFTP/
````

### Get PXE files from syslinux

````
mkdir tmp
cd tmp
wget --output-document syslinux.tar.gz https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.gz
tar xzvf syslinux.tar.gz 

cp syslinux-6.03/bios/{core/pxelinux.0,com32/{menu/{menu,vesamenu}.c32,libutil/libutil.c32,elflink/ldlinux/ldlinux.c32,chain/chain.c32,lib/libcom32.c32}} $VBOX_USER_HOME/TFTP/

cd ..
rm -rf tmp
````

### Get ramdisk and kernel images

_Note_: you must get the files for the version you intend to install (the version on the install media) - otherwise
the installer will fail.

````
wget -P $VBOX_USER_HOME/TFTP/images/centos/7/ http://mirror.centos.org/centos/7/os/x86_64/images/pxeboot/{initrd.img,vmlinuz}
````

## Build a new VM

### Configure the VM in VirtualBox

````
mkdir -p $HOME/VirtualBox\ VMs/lab/disk/

VBoxManage dhcpserver add --netname builder --ip 192.168.200.1 --netmask 255.255.255.0  \
                            --lowerip 192.168.200.50 --upperip 192.168.200.99 --enable

# Create the Bastion VM
VBoxManage createvm --name $BUILDER_VM --groups "/build" --ostype RedHat_64 --register
VBoxManage modifyvm $BUILDER_VM --memory 512 --cpus 1 --audio none --usb off 
VBoxManage modifyvm $BUILDER_VM --nic1 nat --nicbootprio1 1
VBoxManage modifyvm $BUILDER_VM --nattftpfile1 pxelinux.0
VBoxManage modifyvm $BUILDER_VM --biosbootmenu disabled --boot1 net --boot2 disk

# Create the hard drive
VBoxManage createmedium disk --filename "$VBOX_HOME/lab/disk/$BUILDER_VM" --size 8192 --format VDI 
VBoxManage storagectl $BUILDER_VM --add sata --name SATA --controller IntelAhci --portcount 1 --bootable on
VBoxManage storageattach $BUILDER_VM --storagectl SATA --port 0 --type hdd --medium "$VBOX_HOME/lab/disk/$BUILDER_VM.vdi"

# Load the install DVD
VBoxManage storagectl $BUILDER_VM --add ide --name IDE
VBoxManage storageattach $BUILDER_VM --storagectl IDE --port 1 --device 0 --type dvddrive --medium "$VBOX_HOME/iso/CentOS-7-x86_64-Minimal-1708.iso"
````

 ### Get building

 1. Open another terminal and cd into the `http` directory. Then start up a web server with `python -m http.server`
 1. Then start the VM: `VBoxManage startvm $BUILDER_VM --type gui`

## Other stuff

* Delete the VM and its disks: `VBoxManage unregistervm $BUILDER_VM --delete`

## Variations

### Load the install files from a network resource

Mount the ISO (used in an attempt to install over the network: 
 
````
cd http/centos
hdiutil attach -nomount "$VBOX_HOME/iso/CentOS-7-x86_64-Minimal-1708.iso"
mount -t cd9660 /dev/disk4 7
````