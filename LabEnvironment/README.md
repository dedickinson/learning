# Creating a Centos Lab environment

## Create the Router

Configure and start the Router machine (`router.lab.example.com`):

    ./config-router.sh router
    ./start-vm.sh router

In the PXE boot user interface, select the install option for the router. This will install and configure CentOS.

The host-only network card for the router VM is configured on `192.168.200.10` and the host entry is setup in `ansible-hosts.yml`.

Once the installation has completed, start it back up and configure it:

    ./start-vm.sh router
    ansible-playbook site-update.yml
    ansible-playbook site.yml


## Ansible

Configuration file: `ansible.cfg`

To validate a playbook:

    ansible-playbook --check-syntax site.yml

To run the playbook:

    ansible-playbook site.yml
