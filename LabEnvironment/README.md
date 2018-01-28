# The CentOS lab network


## Prepare the host

On the host machine, install:

1. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
1. [Vagrant](https://www.vagrantup.com/)
1. Install Python 3 and `pip`
1. Ansible: `sudo pip install ansible`

Initialise the Vagrant environment and get a Centos 7 box:

````
vagrant init
vagrant box add --provider virtualbox centos/7
````

## Configure the network

The setup will consist of 3 networks:

1. `private` - 10.200.100.0/24
1. `dmz` - 10.200.200.0/24
1. `bastion` - 10.200.250.0/24

The `bastion` network will house bastion servers and allow access from the host system - so I'll configure it as a _Host-only_ network.

The `dmz` network will allow hosts to connect to/from the internet - I'll configure it as a _NAT_ network.

The `private` network will only allow internal connections between VMs - it'll be an _Internal_ network.

To set these up in VirtualBox using the [VBoxManage](https://www.virtualbox.org/manual/ch08.html) command:

### Prep

We'll clear out the VirtualBox networking environment to make way for the lab network.

* List all DHCP servers: `VBoxManage list dhcpservers`
  * Remove any listed using `VBoxManage dhcpserver remove`
* List all Host-only interfaces: `VBoxManage list hostonlyifs`
  * Remove any listed using `VBoxManage hostonlyif remove`
* List all NAT networks: `VBoxManage list natnets`
  * Remove any listed using `VBoxManage natnetwork remove`

### Bastion
````
# This creates an interface named: vboxnet<n>
VBoxManage hostonlyif create 

# To check config:
VBoxManage list hostonlyifs
```` 

## Start the hosts

Test the `Vagrantfile` with: `vagrant validate`

````
vagrant up bastion
````

## Working without Vagrant

### Bastion box

````
# This creates an interface named: vboxnet<n>
VBoxManage hostonlyif create

# Create the Bastion VM
VBoxManage createvm --name lab-bastion --groups "/lab" --ostype RedHat_64 --register
VBoxManage modifyvm lab-bastion --memory 512 --cpus 1 --audio none --usb off 
VBoxManage modifyvm lab-bastion --nic1 hostonly
VBoxManage modifyvm lab-bastion --hostonlyadapter1 vboxnet0

# Create the hard drive
VBoxManage createmedium disk --filename $HOME/VirtualBox\ VMs/lab/disk/bastion --size 8192 --format VDI 
VBoxManage storagectl lab-bastion --add sata --name SATA --controller IntelAhci --portcount 1 --bootable on
VBoxManage storageattach lab-bastion --storagectl SATA --port 0 --type hdd --medium $HOME/VirtualBox\ VMs/lab/disk/bastion.vdi

VBoxManage unattended install lab-bastion --iso=$HOME/VirtualBox\ VMs/CentOS-7-x86_64-Minimal-1708.iso
````

````
VBoxManage startvm --type gui lab-bastion
````

## Ansible

````
ansible-playbook -i ansible-hosts.yml playbook.yml
````
