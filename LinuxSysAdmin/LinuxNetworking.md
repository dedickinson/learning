# Linux Networking

Linux supports IPv4 and IPv6:

    * IPv4 - 32 bit 
    * IPv6 - 128 bit

IPv6 with a 64 bit mask allows suffix to be the MAC address

IPv6 prefix `fe80` is for local networks

## Other docs

* [Firewalls](LinuxNetworkingFirewalls.md)
* [DNS](LinuxNetworkingDns.md)
* [Tunnels](LinuxNetworkingTunnels.md)

## Hostname

Commands:

The [`hostnamectl`](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/networking_guide/sec_configuring_host_names_using_hostnamectl) command
administers the hostname details.

To get hostname details:

    hostnamectl status

To set the hostname:

    sudo hostnamectl set-hostname router.lab.example.com

This does not add the entry into `/etc/hosts`

Note: The `hostname` is the old method to display the hostname.

### Key files

* `/etc/hosts` - local static lookups
* `/etc/hostname` - the hostname 
* `/etc/machine-info` - local machine info, configured via `hostnamectl`
* `/etc/nsswitch.conf` - name service switching
* `/etc/resolv.conf`- resolver config

Can use a "pretty name" by providing the hostname in quotes.

## Checking the network

To get the IP details for the host:

    ip a s

Just the IPv4 details:

    ip -4 a s

For a specific interface:

    ip a s eth0
    ip a s lo

To get the network device information:

    ip link show
    ip -s link show # displays stats


Query the network driver/hardware:

    ethtool eth0

### tracepath

    tracepath www.example.com
    tracepath scanme.nmap.org

### netstat
Network status can be provided by `netstat`

    netstat -t # Active connections
    netstat --numeric --listening # Stats for listening sockets
    netstat -t --numeric --listening # 

    netstat --interfaces # handy for seeing TX/RX for each interface
    netstat --statistics

Check out an interface

### nmap

    yum install nmap

    nmap $(hostname)
    nmap --iflist scanme.nmap.org # displays local interfaces and routes

### sysstat    

`ip` and `netstat` are real time whereas `sysstat` provides historical data for the system (not just networking).

    sudo yum install sysstat
    sudo systemctl enable sysstat
    sudo systemctl enable sysstat

The configuration file `/etc/sysconfig/sysstat` is used to set retention etc

The cron job `/etc/cron.d/sysstat` schedules the `sa1` and `sa2` tools to prepare reports

The reports are stored in `/var/log/sa` - these are binary and read using the `sar` tool.

The `sar` tool is used for reporting on system activity

    sar -A # all stats in current daily file
    sar -u 2 5 # CPU utilisation every 2-secs x 5 checks
    sar -d 2 5 # Block device activity
    sar -n DEV 2 5 # Network devices
    sar -n IP 2 5 # Network IP
    sar -P ALL 2 5 # CPU
    sar -R 2 5 # Memory
    sar -r 2 5 # Memory utilisation
    sar -S 2 5 # Swap space utilisation
    

### Network Service

To get the current status of the network service:

    `systemctl status network`

The scripts that configure a network device are in `/etc/sysconfig/network-scripts/`

Individual interfaces are brought up/down with:

    ifup <device>
    ifdown <device>

## Configuring the IP address

To configure a non-persistent address:

    ip addr add 172.17.67.3/16 dev enp0s8

To set the networking configuration, edit the network script, such as `/etc/sysconfig/network-scripts/ifcfg-eth0`.

## Network manager

NetworkManager is aimed more at desktop/laptop devices rather than servers

* `systemctl status NetworkManager`
* `nmcli connection show`
    * provides tab completion
* `nmcli -p` (nice formatting)
* `nmcli connection add con-name home ifname  enp0s8 type ethernet ip4 192.168.0.99 gw4 192.168.0.1`
* `nmcli con down enp0s8`
    * `nmcli con up home`

