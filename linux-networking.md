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
