# DHCP

## Install the ISC DHCP server

    yum install dhcp

    systemctl enable dhcpd

Config `/etc/dhcp/dhcpd.conf`

    option domain-name-servers <ip>;
    option domain-search “example.vm”;

    default-lease-time 86400;

    max-lease-time 86400;

    ddns-update-style none;

    authorative;

    log-facility local4;

    subnet 192.168.56.0 netmask 255.255.255.0 {
        range 192.168.56.151 192.168.56.254;
}

    host server2 {
        hardware ethernet <macaddr>;
        fixed-address <ip>;
}

Then check the configuration

    dhcpd -t -cf /etc/dhcp/dhcpd.conf

And restart the service

To test from client

    dhclient -r; dhclient
    cat /var/lib/dhclient/dhclient.leases


    