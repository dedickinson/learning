# Linux Networking

## General



## Hostname

Commands:

* `hostnamectl`
  * `hostnamectl set-hostname NAME`
* `hostname` (old) - displays hostname
  * `hostname -f` - FQDN

Key files:

* `/etc/hosts` - local static lookups
* `/etc/machine-info` - local machine info, configured via `hostnamectl`
* `/etc/nsswitch.conf` - name service switching
* `/etc/resolv.conf`- resolver config

Can use a "pretty name" by providing the hostname in quotes.

## DNS

Tools:

* `dig` - DNS Lookup

Centos:

    yum install -y bind-utils

### Multicast DNS

[`avahi`](https://en.wikipedia.org/wiki/Avahi_%28software%29) is a zeroconf network discrovery service, similar to Bonjour

## System time

* `cronyd` and `ntpd`
* `date` and `hwclock` commands
* `timedatectl`

## IP addresses

* IPv4 - 32 bit 
* IPv6 - 128 bit
* `ip addr` 
* `ip a`
* `ip -4 addr`
* `ip a s lo` - display a specific device
* IPv6 with a 64 bit mask allows suffix to be the MAC address
    * fe80 prefix is for local networks
* `ip addr add 172.17.67.3/16 dev enp0s8`
    * does not persist

## Network manager

NetworkManager is aimed more at desktop/laptop devices rather than services

* `systemctl status NetworkManager`
* `nmcli connection show`
    * provides tab completion
* `nmcli -p` (nice formatting)
* `nmcli connection add con-name home ifname  enp0s8 type ethernet ip4 192.168.0.99 gw4 192.168.0.1`
* `nmcli con down enp0s8`
    * `nmcli con up home`

## Network Service

* `systemctl status network`
* `/etc/sysconfig/network-scripts/`
* `ifdown <device>`

# Routing

* `ip route show`
* Old commands
    * `netstat`
    * `route`
* `ip r add default via 192.168.56.104`
    * non persistent
* `/etc/sysconfig/network-scripts` - device config contains gateway and defroute config
* `cat /proc/sys/net/ipv4/ip_forward`
    * set in /etc/sysctl.conf, update with sysctl -p
    * set to 1 to permit forwarding

### NAT

* Enable using `iptables -t nat -A POSTROUTING -o enp0s3 -I MASQUERADE `
    * `iptables -t nat -L`

### Firewalling

* `firewalld` or `iptables`
    * 
* `firewall-cmd —state`
* `systemctl start firewalld.service`
* `firewalld-cmd —get-default-zone`
* `firewalld-cmd —get-zones`
* `firewalld-cmd —get-active-zones`
* `firewalld-cmd —permanent`
    * persists settings
* `firewall-cmd —set-default-zone`

#### Setting rules

* `firewall-cmd —list-all`
* 