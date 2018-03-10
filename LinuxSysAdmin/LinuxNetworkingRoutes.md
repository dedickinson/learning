# Routing

To see routes:

    ip route show

    # Same thing, but shorter
    ip r s

The `route` command has been replaced by `ip r s`

* `ip r add default via 192.168.56.104`
    * non persistent
* `/etc/sysconfig/network-scripts` - device config contains gateway and defroute config

## IP Forwarding

To check if IP forwarding is enabled:

    sysctl net.ipv4.ip_forward

    #or
    cat /proc/sys/net/ipv4/ip_forward

To setup IP forwarding, edit `/etc/sysctl.conf` to feature:

    net.ipv4.ip_forward = 1

Load the changes with:

    sysctl -p
   

### NAT

* Enable using `iptables -t nat -A POSTROUTING -o enp0s3 -I MASQUERADE `
    * `iptables -t nat -L`
    