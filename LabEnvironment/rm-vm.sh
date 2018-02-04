#!/bin/bash -e

BUILDER_VM=${1-builder}

vm_exists=$(VBoxManage list vms | grep "$BUILDER_VM" | cut -f 1 -d " ")

if [ "$vm_exists" == "\"$BUILDER_VM\"" ]
then
    VBoxManage unregistervm $BUILDER_VM --delete
else
    echo "No VM with name '$BUILDER_VM' exists - nothing to do."
fi

