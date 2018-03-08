# Kerberos

## Configure NTP

Server 1 uses external time, Server 2 uses Server 1 as a time server

### Server 1

Install `ntp`:

    yum install ntp

Start and enable ntpd

    systemctl start ntpd
    systemctl enable ntpd
    firewall-cmd --add-service=ntp --permanent
    firewall-cmd --reload

Allow local network access in `/etc/ntp.conf` by adding a restrict line

    restrict 172.20.63.0 mask 255.255.0.0 nomodify notrap

Query the time servers:

    ntpq -p

Make sure /etc/hosts or dns have host entries

### Server 2

Install `ntp`:

    yum install ntp

Start and enable ntpd

    systemctl start ntpd
    systemctl enable ntpd

Edit `/etc/ntpd.conf`, to remove the public ntp servers and point to master using the `iburst` and `prefer` flags. 

    server server1.lab.example.com iburst prefer

Restart ntpd and check:

    systemctl restart ntpd
    ntpq -p

# Install and Configure

## Random number generator

Need a random number generator

    yum install rng-tools
    systemctl enable rngd
    vi /usr/lib/systemd/system/rngd.service

Change ExecStart value to

    /sbin/rngd -f -r /dev/urandom

Then

    systemctl daemon-restart
    systemctl start rngd
    
### Kerberos install

    yum install krb5-server krb5-workstation pam_krb5

    cd /var/kerberos/krb5kdc

    ls

    cat kadm5.acl
    cat kdc.conf

Default config uses example.com

Client file

    /etc/krb5.com

Set kdc and admin_server, and domain_realm, default_realm

    kdb5_util create -s -r EXAMPLE.COM

Enable and start krb5kdc kadmin

    netstat -ltn

    firewall-cmd —add-service=kpasswd —permanent

    firewall-cmd —add-service=kerberos —permanent

    Firewall-cmd —add-port=749/tcp —permanent

    firewall-cmd —reload

Configure kerberos

    kadmin.local
    listprincs
    addprinc root/admin

    addprinc fred

    addprinc —random host/server1.example.com

    ktadd host/server1.example.com

    quit

### Authenticate to Ssh

On server1

    vi /etc/ssh/ssh_config

Set GSSAPIAuthentication and GSSAPIDelegateCredentials to yes

    systemctl reload sshd

    authconfig —enablekrb5 —update

As a standard user

    klist # to check current tokens

    kinit 

    klist # will now have key

    ssh server1.example.com

Logs in using the kerberos key

To remove the key

    kdestroy

To configure another server to use kerberos 

    yum install krb5-workstation pam_krb5

Copy the /etc/krb5.conf file from server1

    kadmin
    listprincs

    addprinc -randkey host/server2.example.com

    ktadd host/server2.example.com

    quit

Setup SSH as before then

    authconfig-tui

    systemctl reload sshd

Then as a normal user

    kinit
    klist
 
SSH into server1





