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

## Random number generator

Need a random number generator

    yum install rng-tools
    systemctl enable rngd
    vi /usr/lib/systemd/system/rngd.service

Change ExecStart value to

    /sbin/rngd -f -r /dev/urandom

Then

    systemctl daemon-reload
    systemctl start rngd
    
## Kerberos install

    yum install krb5-server krb5-workstation pam_krb5

### Configure

    cd /var/kerberos/krb5kdc

Edit `kdc.conf` to use the correct domain:
    
    [kdcdefaults]
     kdc_ports = 88
     kdc_tcp_ports = 88

    [realms]
     LAB.EXAMPLE.COM = {
      #master_key_type = aes256-cts
      acl_file = /var/kerberos/krb5kdc/kadm5.acl
      dict_file = /usr/share/dict/words
      admin_keytab = /var/kerberos/krb5kdc/kadm5.keytab
      supported_enctypes = aes256-cts:normal aes128-cts:normal des3-hmac-sha1:normal arcfour-hmac:normal camellia256-cts:normal camellia128-cts:normal des-hmac-sha1:normal des-cbc-md5:normal des-cbc-crc:normal
     }
    
Edit `kadm5.acl`:

    */admin@LAB.EXAMPLE.COM *

Configure the client file `/etc/krb5.conf`

    # Configuration snippets may be placed in this directory as well
    includedir /etc/krb5.conf.d/

    [logging]
     default = FILE:/var/log/krb5libs.log
     kdc = FILE:/var/log/krb5kdc.log
     admin_server = FILE:/var/log/kadmind.log

    [libdefaults]
     dns_lookup_realm = false
     ticket_lifetime = 24h
     renew_lifetime = 7d
     forwardable = true
     rdns = false
     default_realm = LAB.EXAMPLE.COM
     default_ccache_name = KEYRING:persistent:%{uid}

    [realms]
    LAB.EXAMPLE.COM = {
      kdc = server1.lab.example.com
      admin_server = server1.lab.example.com
     }

    [domain_realm]
    lab.example.com = LAB.EXAMPLE.COM

Setup the Kerberos database:

    kdb5_util create -s -r LAB.EXAMPLE.COM

Enable and start `krb5kdc` and `kadmin`:

    systemctl enable {krb5kdc,kadmin}
    systemctl start {krb5kdc,kadmin}
    
    netstat -ltnp

#### Firewall

    firewall-cmd --add-service=kpasswd --permanent

    firewall-cmd --add-service=kerberos --permanent

    firewall-cmd --add-port=749/tcp --permanent

    firewall-cmd --reload

### Configure kerberos

Enter the Kerberos CLI:
    kadmin.local
    
Then configure some principals:

    listprincs

    addprinc root/admin

    addprinc penguin

    addprinc -randkey host/server1.lab.example.com
    ktadd host/server1.lab.example.com
    
    addprinc -randkey host/server2.lab.example.com
    ktadd host/server2.lab.example.com

    quit

# Authenticate to SSH

On Server1

    vi /etc/ssh/ssh_config

Set `GSSAPIAuthentication` and `GSSAPIDelegateCredentials` to `yes` and reload SSHD

    systemctl reload sshd

Enable:

    authconfig --enablekrb5 --update

As a standard user (e.g. `penguin`):

    kinit 

    klist # will now have key

    ssh server1.lab.example.com

This logs in using the kerberos key

To remove the key

    kdestroy

## Server 2 - Kerberos client

To configure another server to use kerberos 

    yum install krb5-workstation pam_krb5

Copy the /etc/krb5.conf file from server1
    
Then as a normal user (e.g. `penguin`)

    kinit
    klist
 
SSH into server1:

    ssh server1.lab.example.com

### Configure Kerberos for login:

Start `authconfig-tui` and change off LDAP Auth over to Kerberos Auth.

## Manage kerberos

Use `kadmin` to manage objects such as users. Type `?` in the cli for a list of commands (e.g. `change_password`).




