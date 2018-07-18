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

- Create a resource group and virtual network: [`vnet.azcli`](vnet.azcli)

