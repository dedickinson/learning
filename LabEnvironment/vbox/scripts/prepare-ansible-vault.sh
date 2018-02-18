#!/bin/bash -e

# Prepare an Ansible vault that will be used to store passwords etc in the lab machines 
# This script will generate random passwords for you 
cd "$(dirname "$0")"

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

rootpw=$(./genpasswd.py)
ansiblepw=$(./genpasswd.py)

encrootpw=$(./mkpasswd.py $rootpw)
encansiblepw=$(./mkpasswd.py $ansiblepw)

echo Preparing vault file

cat>$vault_file<<EOM
---
ansible_user_password: "$encansiblepw"
ansible_user_password_plain: "$ansiblepw"
root_user_password: "$encrootpw"
root_user_password_plain: "$rootpw"
EOM

ansible-vault encrypt $vault_file

echo Created $vault_file

cd -
