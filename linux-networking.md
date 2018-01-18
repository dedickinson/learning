# Linux Networking

## General tools

* `dig` - DNS Lookup

## Hostname

Commands:

* `hostnamectl`
  * `hostnamectl set-hostname NAME`
* `hostname` (old) - displays hostname
  * `hostname -f` - FQDN

* Key files:

* `/etc/hosts` - local static lookups
* `/etc/nsswitch.conf` - name service switching
* `/etc/resolv.conf`- resolver config

Can use a "pretty name" by providing the hostname in quotes.
