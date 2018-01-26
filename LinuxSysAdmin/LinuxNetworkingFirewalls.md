# Firewalls

## `firewalld` or `iptables`?

`iptables` is the older approach, `firewall-cmd` and `ucfw` are seen in newer dists but iptables is the underlying system.

## `firewall-cmd`

Check the firewall service state:

    firewall-cmd —-state

To start the service:

    systemctl start firewalld.service

When making changes, include the `permanent` switch to survive reboot:

    firewalld-cmd —-permanent

### Zones    
* `firewalld-cmd —get-default-zone`
* `firewalld-cmd —get-zones`
* `firewalld-cmd —get-active-zones`
* `firewall-cmd —set-default-zone`

### Setting rules

* firewall-cmd —list-all
* firewall-cmd —permanent —remove-service=ssh
    * firewall-cmd —reload
    * can pass array of services []

### Masquerading
* firewall-cmd —list-all
* firewall-cmd —remove-masquerade

### Custom services

* firewall-cmd —list-services —zone=
* XML files for config
* firewall-cmd —permanent —new-Service=“puppet”
* /etc/firewalld/services/
* firewall-cmd —permanent —add-Service=puppet —zone=

## iptables

* iptables -l
* iptables -A INPUT -i lo -j ACCEPT
* iptables -A INPUT -m conntrack —ctstate ESTABLISHED,RELATED -I ACCEPT
    * Makes firewall stateful by allowing outgoing to get back in
* iptables -A INPUT -p tcp —sport 22 -j ACCEPT
* iptables -L
* iptables -nvL
* iptables-save > fwon
* iptables-restore < fwon
* iptables -A INPUT -j DROP
* iptables -F
    * flushes the table

Policies 
Leave ACCEPT for the chains and have a DROP as the last rule in each chain

* Yum install iptables-services
* vi /etc/sysconfig/iptables
* systemctl disable firewalld
* systemctl enable iptables
* systemctl start iptables