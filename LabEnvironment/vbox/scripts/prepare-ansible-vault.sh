#!/bin/bash -e

# Prepare an Ansible vault that will be used to store passwords etc in the lab machines 
# This script will generate random passwords for you (or call `./prepare-ansible-vault.sh <vault_dir> <vault_name> manual` to set them yourself)

vault_dir=$1    # ~/.ansible-vaults
vault_file=$vault_dir/$2   # $vault_dir/lab.yml

if [ ! -d $vault_dir ]; then 
    mkdir chmod 700
    chmod 700 $vault_dir
fi

if [ -e $vault_file ]; then
    echo "Vault already exists (won't overwrite): $vault_file"
    exit 1
fi

if [ "$3" == "manual" ]; then
    read -sp 'Root user password: ' rootpw
    echo
    read -sp 'Ansible user password: ' ansiblepw
    echo
else
    rootpw=$(openssl rand -base64 24)
    ansiblepw=$(openssl rand -base64 24)
fi

encrootpw=$(openssl passwd -1 -salt $(date "+%Y%m%d") $rootpw)
encansiblepw=$(openssl passwd -1 -salt $(date "+%Y%m%d") $ansiblepw)

echo Preparing vault file

cat>$vault_file<<EOM
---
ansible_user_password: "$encansiblepw"
root_user_password: "$encrootpw"
EOM

ansible-vault encrypt $vault_file

echo Created $vault_file
