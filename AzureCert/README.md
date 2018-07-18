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
1. Now get serious and create a management resource group and some resources for further work: [`management.azcli`](management.azcli)
