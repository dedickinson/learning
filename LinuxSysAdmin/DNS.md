# DNS

    yum install bind bind-utils

    systemctl enable named
    systemctl start named

    netstat -ltn #port 53,953

Open up the firewall as appropriate.

Try out DNS

    dig www.google.com @127.0.0.1

The DNS server is a caching only server answering on `127.0.0.1`

## DNS files and locations

- The `/etc/named.conf` file sets the database etc.
- `/var/named` contains the databases etc
- Check out the log file: `/var/named/data/named.run`

## Configuration

Edit `/etc/named.conf`

- `listen-on` sets the port and the host address
- `allow-query sets` which hosts can query and can accept a cidr address and “localnets”

````c
options {
    listen-on port 53 { 172.16.1.1; };
    listen-on-v6 port 53 { ::1; };
    directory 	"/var/named";
    dump-file 	"/var/named/data/cache_dump.db";
    statistics-file "/var/named/data/named_stats.txt";
    memstatistics-file "/var/named/data/named_mem_stats.txt";
    allow-query     { 172.16.0.0/16; };

    //Allows for a caching server
    recursion yes;

    dnssec-enable yes;
    dnssec-validation yes;

    /* Path to ISC DLV key */
    bindkeys-file "/etc/named.iscdlv.key";

    managed-keys-directory "/var/named/dynamic";

    pid-file "/run/named/named.pid";
    session-keyfile "/run/named/session.key";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "lab.example.com." {
    type master;
    file "named.lab";
    allow-update { none; };
};

zone "." IN {
    type hint;
    file "named.ca";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
````

Restart:

    named-checkconf
    systemctl restart named

Check 

    dig www.google.com @127.0.0.1

## Configure forwarding

In options section, add

    forwarders {8.8.8.8; 8.8.4.4};
    forward only;

Check

    dig www.example.com @127.0.0.1


## Create a forward lookup zone

Edit named.conf by adding

    zone "lab.example.com." {
        type master;
        file "named.lab";
        allow-update { none; };
    }

Then

    named-checkconf

Create `/var/named/lab.conf`:

    cd /var/named
    cp named.empty lab.conf
    chgrp named lab.conf

Edit `/var/named/named.lab`:

````dns
$TTL 3H
$ORIGIN lab.example.com.

lab.example.com. IN SOA router.lab.example.com. root.lab.example.com. (
    1 ; serial - increment this on changes
    1D ; refresh
    1H ; retry
    1W ; expire
    3H) ; minimum

lab.example.com. NS router.lab.example.com.
router A  172.16.1.1
time  CNAME  router
````

Then:

    # Check the zone file:
    named-checkzone lab.example.com named.lab

    # Restart the service:
    systemctl restart named

    # View the log:
    cat /var/named/data/named.run

Run some tests:

    dig router.lab.example.com @172.16.1.1
    dig time.lab.example.com @172.16.1.1
    
    dig -t NS lab.example.com @172.16.1.1

## DNS queries with python

    yum install python-dns

in python

    import dns.resolver





