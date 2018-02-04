#!/bin/bash -e


VBoxManage hostonlyif create
VBoxManage hostonlyif ipconfig vboxnet0 --ip 192.168.200.1 --netmask 255.255.255.0

VBoxManage dhcpserver add --netname HostInterfaceNetworking-vboxnet0 --ip 192.168.200.1 --netmask 255.255.255.0  \
                            --lowerip 192.168.200.50 --upperip 192.168.200.99 --enable

VBoxManage dhcpserver modify --ifname vboxnet0 --enable

