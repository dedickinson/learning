# CIFS/Samba shares

NOT COMPLETE

## Setup the server

### Install

  yum install samba
  
  firewall-cmd --add-service=samba --permanent
  firewall-cmd --reload
  systemctl enable smb
  systemctl start smb
  
### Configure

The main configuration file is in `/etc/samba/smb.conf`:

````
[global]
        workgroup = SAMBA
        security = user
        netbios name = server1
        passdb backend = tdbsam

        printing = cups
        printcap name = cups
        load printers = yes
        cups options = raw

[homes]
        comment = Home Directories
        valid users = %S, %D%w%S
        browseable = No
        read only = No
        inherit acls = Yes

[printers]
        comment = All Printers
        path = /var/tmp
        printable = Yes
        create mask = 0600
        browseable = No

[print$]
        comment = Printer Drivers
        path = /var/lib/samba/drivers
        write list = root
        create mask = 0664
        directory mask = 0775
````

Run `testparm` to check the configuration.

### Configure a user account

Create a user with no shell:

  useradd -M -s /sbin/nologin simba
  passwd simba
  smbpasswd -a simba
  smbpasswd -e simba
  
Create a shared directory

  mkdir -p /share/samba
  
Add a new entry to `/etc/samba/smb.conf`:

  [myshare]
        path = /share/samba
        read only = no

Restart the service:

  systemctl restart smb
  
## Setup a client

  yum install cifs-utils
  
