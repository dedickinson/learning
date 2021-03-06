# OpenLDAP

See also: 

- https://www.itzgeek.com/how-tos/linux/centos-how-tos/step-step-openldap-server-configuration-centos-7-rhel-7.html
- https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system-level_authentication_guide/openldap
- https://docs.oracle.com/cd/E52668_01/E54669/html/ol7-s9-auth.html

## Check hostname

    hostnamectl #check it’s fully qualified

Make sure host is in /etc/hosts

## Install

    yum -y install openldap openldap-clients openldap-servers migrationtools

## Start and check

    systemctl start slapd
    systemctl enable slapd
    systemctl status slapd
    
    firewall-cmd --permanent --add-service=ldap
    firewall-cmd --permanent --add-service=ldaps
    firewall-cmd --reload
    
    netstat -antup

## Configure

Edit `/etc/openldap/ldap.conf` to be:

    BASE    dc=lab,dc=example,dc=com
    URI     ldap://server1.lab.example.com

    #SIZELIMIT      12
    #TIMELIMIT      15
    #DEREF          never

    TLS_CACERTDIR   /etc/openldap/certs
    TLS_REQCERT     allow

    # Server settings
    TLSVerifyClient never

    # Turning this off breaks GSSAPI used with krb5 when rdns = false
    SASL_NOCANON    on

Configure `~/db.ldif`:

    dn: olcDatabase={2}hdb,cn=config
    changetype: modify
    replace: olcSuffix
    olcSuffix: dc=lab,dc=example,dc=com

    dn: olcDatabase={2}hdb,cn=config
    changetype: modify
    replace: olcRootDN
    olcRootDN: cn=ldapadm,dc=lab,dc=example,dc=com

    dn: olcDatabase={2}hdb,cn=config
    changetype: modify
    replace: olcRootPW
    olcRootPW: {SSHA}xIiZHK3B5wXOCmojmcyVZ3ft720VAc6x

Then run `ldapmodify -Y EXTERNAL  -H ldapi:/// -f db.ldif`

Configure `~/monitor.ldif`:

    dn: olcDatabase={1}monitor,cn=config
    changetype: modify
    replace: olcAccess
    olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" read by dn.base="cn=ldapadm,dc=lab,dc=example,dc=com" read by * none

Then run `ldapmodify -Y EXTERNAL  -H ldapi:/// -f monitor.ldif`

### Configure certificate

Create a certificate (make sure you set the Common Name to server1.lab.example.com):

    openssl req -new -x509 -nodes -out /etc/openldap/certs/labexamplecomldapcert.pem -keyout /etc/openldap/certs/labexamplecomldapkey.pem -days 365

Then run

    chown -R ldap:ldap /etc/openldap/certs/*.pem
    chmod 0400 /etc/openldap/certs/*.pem

Configure `~/certs.ldif`:

    dn: cn=config
    changetype: modify
    replace: olcTLSCertificateFile
    olcTLSCertificateFile: /etc/openldap/certs/labexamplecomldapcert.pem

    dn: cn=config
    changetype: modify
    replace: olcTLSCertificateKeyFile
    olcTLSCertificateKeyFile: /etc/openldap/certs/labexamplecomldapkey.pem

Then run `ldapmodify -Y EXTERNAL  -H ldapi:/// -f certs.ldif`

## Test the config

    slaptest -u
    
## Copy the database

    cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
    chown ldap:ldap /var/lib/ldap/*
    
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif 
    ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif
    
Edit `~/base.ldif`

    dn: dc=lab,dc=example,dc=com
    dc: lab
    objectClass: top
    objectClass: domain

    dn: cn=ldapadm,dc=lab,dc=example,dc=com
    objectClass: organizationalRole
    cn: ldapadm
    description: LDAP Manager

    dn: ou=People,dc=lab,dc=example,dc=com
    objectClass: organizationalUnit
    ou: People

    dn: ou=Group,dc=lab,dc=example,dc=com
    objectClass: organizationalUnit
    ou: Group

Then run

    ldapadd -x -W -D "cn=ldapadm,dc=lab,dc=example,dc=com" -f base.ldif

## Create a Group

And edit the `group.ldif` file:

    dn: cn=employees,ou=Group,dc=lab,dc=example,dc=com
    cn: employees
    gidNumber: 5001
    objectClass: top
    objectclass: posixGroup

ldapadd -x -W -D "cn=ldapadm,dc=lab,dc=example,dc=com" -f group.ldif

## Create users

Create a new user called `penguin` and set a password:

    useradd penguin
    passwd penguin

Use the migrationtools to create an ldif:

    grep penguin /etc/passwd > penguin-passwd
    /usr/share/migrationtools/migrate_passwd.pl penguin-passwd user.ldif
    vi user.ldif

And edit the `user.ldif` file:

    dn: uid=penguin,ou=People,dc=lab,dc=example,dc=com
    uid: penguin
    cn: penguin
    objectClass: top
    objectClass: account
    objectClass: posixAccount
    objectClass: shadowAccount
    userPassword: {crypt}$6$3.5HTNtR$VTsVfJGnjrQdD5fWeyVyP5ZqzqPR4c.tHSrizGOcOpUmpd9quOpi8WIUaYNVbmH2.lKDuVsxR7LaAcTL7I7xH/
    shadowLastChange: 17597
    shadowMin: 0
    shadowMax: 99999
    shadowWarning: 7
    loginShell: /bin/bash
    uidNumber: 5001
    gidNumber: 5001
    homeDirectory: /home/penguin

Then run:

    ldapadd -x -W -D "cn=ldapadm,dc=lab,dc=example,dc=com" -f user.ldif

## Query

Request all objects:

    ldapsearch -x -b 'dc=lab,dc=example,dc=com' '(objectclass=*)'
    
Search penguin:

    ldapsearch -x -b 'dc=lab,dc=example,dc=com' '(uid=penguin)'
    ldapsearch -x -b dc=lab,dc=example,dc=com "(&(objectclass=account) (uid=penguin))"
    ldapsearch -x -b dc=lab,dc=example,dc=com "(&(objectclass=account) (uid=penguin))" uid homeDirectory
    
Ask about the Person class:

    ldapsearch -x -LLL -b cn=Subschema -s base '(objectClass=subschema)' attributeTypes dITStructureRules objectClasses Person

# LDAP Client systems

Make sure `/etc/hosts` is correctly set up with the server hostnames and addresses

## Install

    yum install openldap-clients nss-pam-ldapd
    
Try out a query:

    ldapsearch -x
    ldapsearch -x -LLL ldap://server1.lab.example.com -b dc=lab,dc=example,dc=com
    ldapsearch -x -LLL ldaps://server1.lab.example.com -b dc=lab,dc=example,dc=com
    ldapsearch -x ldaps://server1.lab.example.com -b dc=lab,dc=example,dc=com "(&(objectclass=account) (uid=penguin))"
    ldapsearch -x ldaps://server1.lab.example.com -b dc=lab,dc=example,dc=com "(uid=penguin)"
    
## Configure

Create user home directories ad-hoc:

    authconfig --enablemkhomedir --update

Use the `authconfig-tui` tool:

    authconfig-tui
    
Make sure you:

* Enable LDAP for User Information **AND** Authentication
    
Check the auth order:

    grep passwd /etc/nsswitch.conf

The `penguin` user now appears:

    getent passwd|grep penguin
    getent group employees

List users and groups:

    grep ldap /etc/nsswitch.conf

To connect to the LDAP server without TLS, edit `TLS_REQCERT` in `/etc/openldap/ldap.conf`:

    TLS_CACERTDIR /etc/openldap/cacerts
    TLS_REQCERT never

    # Turning this off breaks GSSAPI used with krb5 when rdns = false
    SASL_NOCANON    on
    URI ldap://server1.lab.example.com
    BASE dc=lab,dc=example,dc=com

# Tips

- After changing the client connection, run `systemctl restart nslcd`
- Generally don't configure the ldap server as an ldap client
- Edit `etc/nsswitch.conf` to change use of LDAP info

## Change an entry

To change a property, create a file (e.g. `user-mod.ldif`):

    dn: uid=penguin,ou=People,dc=lab,dc=example,dc=com
    changetype: modify
    replace: gidNumber
    gidNumber: 5001
   
Then run:

    ldapmodify -x -W -D "cn=ldapadm,dc=lab,dc=example,dc=com" -f user-mod.ldif

