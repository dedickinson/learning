#!/bin/bash -e
ipaddr=$1 #192.168.200.1
ifname=$2 #vboxnet0

existifcount=$(VBoxManage list hostonlyifs|grep ^Name|wc -l|tr -d ' ')

if (( existifcount > 1 )); then
    echo "ERROR: $existifcount hostonly interfaces already exist:"
    echo $(VBoxManage list hostonlyifs|grep ^Name)
    exit 1
fi

existifipaddr=$(VBoxManage list hostonlyifs|grep ^IPAddress|tr -s ' '|cut -d ' ' -f2)
existifname=$(VBoxManage list hostonlyifs|grep ^Name|tr -s ' '|cut -d ' ' -f2)

if (( $existifcount == 1 )); then
    if [ "$existifipaddr" != "$ipaddr" ] && [ "$ifname" != "$existifname" ]; then
        echo "ERROR: The existing hostonly interface doesn't meet our needs"
        exit 1
    else
        echo "Already configured"
        exit 0
    fi
else
    VBoxManage hostonlyif create
    VBoxManage hostonlyif ipconfig $ifname \
                                    --ip $ipaddr \
                                    --netmask 255.255.255.0

    VBoxManage dhcpserver add --netname HostInterfaceNetworking-vboxnet0 \
                              --ip 192.168.200.1 \
                              --netmask 255.255.255.0  \
                              --lowerip 192.168.200.50 \
                              --upperip 192.168.200.99 \
                              --enable
fi
