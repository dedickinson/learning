# Routing

To see routes:

    ip route show

    # Same thing, but shorter
    ip r s

The `route` command has been replaced by `ip r s`


* `ip r add default via 192.168.56.104`
    * non persistent
* `/etc/sysconfig/network-scripts` - device config contains gateway and defroute config
* `cat /proc/sys/net/ipv4/ip_forward`
    * set in /etc/sysctl.conf, update with sysctl -p
    * set to 1 to permit forwarding

### NAT

* Enable using `iptables -t nat -A POSTROUTING -o enp0s3 -I MASQUERADE `
    * `iptables -t nat -L`
    