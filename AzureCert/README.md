# Basics

## Install

The CLI:

    pip install azure-cli --user

Or, use the Dockerfile in this directory (it also has the Powershell CLI):

    # Build
    docker build -t az .

    # Run
    docker run -it az

## Logon

With CLI:

    az login

Powershell:

    Connect-AzureRMAccount

## Doing stuff in `az` cli

1. Create a resource group and virtual network: [`vnet.azcli`](vnet.azcli)
    - The script exports [the basic-vnet template](templates/basic-vnet.json) that will be used later to create a failover environment
1. Setup a basic Linux VM: [`vm.azcli`](vm.azcli)
1. Create a management resource group and some resources for further work: [`management.azcli`](management.azcli)

### Creating a CentOS 7 image

Extend the basic VM example to create an image: [`vm-image.azcli`](vm-image.azcli)

Logs are in `/var/log/cloud-init-output.log`

Reference: https://docs.microsoft.com/en-us/azure/virtual-machines/linux/cloudinit-prepare-custom-image

### Scaleset with Load Balancer

See [`scaleset.azcli`](scaleset.azcli)

### Kubernetes

See [`aks.cli`](aks.cli)

### DSC

1. Create an Azure Files share
1. Add the username/password to the Automation Account credentials
    1. Use the username/password provided in the Linux connection details for the share
    1. The username is the name of the storage account
1. Create a new DSC config using [`Website.ps1`](dsc-iis/Website.ps1). Compile it with the required parameters
    1. CREDENTIALSNAME: _The name of the Automation Account credential you created_
    1. WEBFILESPATH: `\\<Storage Account Name>.file.core.windows.net\<Share Name>`
1. Assign to your Windows VM of choice

Refs: 

- https://docs.microsoft.com/en-us/azure/automation/automation-dsc-getting-started
- https://docs.microsoft.com/en-us/powershell/dsc/quickstart
