# Creating a Centos Lab environment

There are 3 subnets in the lab environment:

* `labnetwork-internal`
* `labnetwork-dmz`
* `labnetwork-external`

The main VMs are:

* `router.lab.example.com` is the central router, featuring:
  * Network connectivity for the subnets and associated firewalling
  * [DNSMasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) provided DNS, DHCP and PXE booting for the network
  * [Squid caching proxy](http://www.squid-cache.org/) as a general cache as well as a YUM cache (handy for reducing the downloads)

VirtualBox is used to run the lab VMs. I've chosen to configure the environment directly using the `VBoxManage`
command as I found that `Vagrant` didn't quite give me the level of network configuration I wanted.
The various scripts for configuring and managing the VMs can be found under `vbox`.

Ansible is used to configure the lab VMs and the various Ansible playbooks are found in the `ansible` directory.

The various instructions provided here are for an OS X-based host. However, many of the steps easily translate to
other platforms.

## Before you start

An Ansible Vault is used to hold the user login information used for installs etc. The `lab-provision-vault.yml` 
playbook will prepare the vault for you but, should you need the details, run `ansible-vault view ~/.ansible-vaults/lab.yml`.

    ansible-playbook lab-provision-vault.yml

Preparing the Lab environment is done through an Ansible playbook:

    ansible-playbook -v lab-provision.yml --ask-vault-pass

This configures all VMs, ready to start installs. Refer to the __Working with the Virtual Machines__ for OS installation details.

Once all VMs have had an OS installed, the quick way to start everything up is:

    ansible-playbook -v lab-start.yml

## Working with the Virtual Machines

### The Router VM

The Router VM (`router.lab.example.com`) is the central networking VM and needs to be started up first. It also
has some specific requirements as no other lab components exist before it starts up.

VirtualBox provides the ability to [run PXE Boots on NAT interfaces](https://www.virtualbox.org/manual/ch06.html#nat-tftp) and this is used to install the Router VM.

I've elected to use the [Predictable Interface Names](https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/) approach - mainly to help my learning. On the router VM, the devices are:

VBox Name | Type               | IP/CIDR           | Device 
----------|--------------------|-------------------| --------
nic1      | nat                | dhcp              | enp0s3 
nic2      | hostonly           | 192.168.200.10/24 | enp0s8
nic3      | bridged            | dhcp              | enp0s9
nic4      | intnet - internal  | 192.168.1.1/24    | enp0s10
nic5      | intnet - dmz       | 192.168.100.1/24  | enp0s16
nic6      | intnet - external  | 192.168.200.1/24  | enp0s17


Run the `lab-vm-start.yml` playbook to start an install:

    ansible-playbook -v lab-vm-install.yml --extra-vars "vm_name=router" --ask-vault-pass

In the PXE boot user interface, select the install option for the router. This will install and configure CentOS.

The host-only network card for the router VM is configured on `192.168.200.10` and the host entry is setup in `ansible-hosts.yml`.

Once the installation has completed, start it back up:

    ansible-playbook -v lab-vm-start.yml --extra-vars "vm_name=router"

Change over to the `ansible` directory and configure the VM:

````bash
ansible-playbook -v site-update.yml
ansible-playbook -v site.yml
````

### References

* The following gist really helped out on this: https://gist.github.com/jtyr/816e46c2c5d9345bd6c9
* [VirtualBox - Global Configuration Data](https://www.virtualbox.org/manual/ch10.html#idp47569015460640) - check this out to determine where `VBOX_USER_HOME` is configured
* [Anaconda Boot Options](http://anaconda-installer.readthedocs.io/en/latest/boot-options.html)
* [CentOS Community kickstarts](https://github.com/CentOS/Community-Kickstarts)

## Other VM stuff

* Shut down the lab VMs: `ansible-playbook site-shutdown.yml`
* Delete the VM and its disks: `VBoxManage unregistervm $BUILDER_VM --delete`

## Ansible

Configuration file: `ansible.cfg`

To validate a playbook:

    ansible-playbook --check-syntax site.yml

To run the playbook:

    ansible-playbook site.yml
