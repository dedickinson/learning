# SELinux

- Mandatory access control
- Kernel module, policy files and tools
- Selinux is in addition to standard Linux permissions
- Selinux limits the resources a service can access, even when run as root.

## Security contexts

Added to files, view with

    ls -Z

Contexts are made up of

- user
- role
- type
- level

The user is an selinux user, not a Linux user.

To see process details

    ps xZ

Ordinary users run in the unconfined domain as the traditional access controls are enough. The focus is on processes with elevated privileges.

Example:

    ls -Z /bin/passwd

Has policy type passwd_exec_t that allows transition to the passwd_t domain:

    ps -xZ | grep passwd

The /etc/shadow file has type shadow_t and the policy allows the passwd_t domain to write to shadow_t file types.

## Commands

Current status:

    sestatus

Reports on /etc/selinux/config

Change the mode

    setenforce

Package: setools-console

    seinfo
    seinfo -x
    seinfo --stats

To fix a mislabelled web file:

    ls -Z <file>
    setenforce 0
    
To find the audit log file:

    pgrep auditd
    lsof <id>
    
Log is /var/log/audit

    grep AVC /var/log/audit/audit.log

Find “denied” entry.

    restorecon <file>
    

## Modes and context

Example for seeing the context on a file:

    ls -Z /etc/shadow

Determine current mode

    getenforce
    sestatus

Config: /etc/selinux/config

Change enforce mode

    setenforce 0
    setenforce 1

Check process context:

    ps -Z

Check user

     id -Z

## Log files

    /var/log/audit/audit.log

    ausearch -m avc
    

Change context

    chcon -t unlabelled_t /etc/shadow 

To restore

    restorecon /etc/shadow

To manage

    semanage fcontext -l

Listed in

    /etc/selinux/targeted/contexts/files

## Modifying policies

SELinux Booleans

    getsebool -a

    semanage boolean -l

    getsebool http_read_user_content
    setsebool http_read_user_content on
    setsebool -P http_read_user_content on # makes config permanent 

### Working with network ports

    semanage port -l

    semanage port -a -t ssh_port_t -p tcp 2222
    
## Working with services

### Install and configure SAMBA

Install and configure SAMBA for CIFS file sharing.

    yum list samba*
    
    yum install samba*
    
Then

    mkdir -m 1777 /share
    
    ls -ld /share
    
    touch /share/test.txt
    
Setup the share in ‘/etc/samba/smb.conf’. Set the following share config

    [share]
    path=/share
    writable=yes
    
Test using ‘testparm’.

    systemctl start nmb smb
    systemctl enable nmb smb
    
    smbpasswd -a root
    smbclient -L //localhost
    
    smbclient //localhost/share
    
    ls
    
The last command fails, so diagnose:

    getenforce #check selinux state
    
    ausearch -m avc #find smb issue
    
Look at the ‘scontext’ vs the ‘tcontext’ - they don’t match. The doco in ‘/etc/samba/smb.conf’ will guide a fix. But there’s other approaches

    ls -dZ /share/
    
    yum whatprovides */sbin/semanage
    
    yum install policycoreutils-python
    
    semanage fcontext -a -t samba_share_t '/share(/.*)?'
    
    restorecon -R /share

## Another config approach

    mkdir -m 1777 /accounts
    
Edit samba config and add

    [accounts]
    path=/accounts
    writable=yes
    
Then configure selinux for samba using a global approach:

    setsebool -P samba_export_all_rw 1
    systemctl restart smb
    
    smbclient -L //localhost
    smbclient //localhost/accounts

## Configure a Service to be permissive

    yum install setools
    seinfo —permissive
    
    semanage permissive -a smbd_t
    
    


