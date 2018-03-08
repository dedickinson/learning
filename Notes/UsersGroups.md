# Users and groups

Local users are listed in `/etc/passwd`

Explore the various auth elements:

    getent passwd 
    getent passwd penguin

    # name services:
    grep passwd /etc/nsswitch.conf

    # view databases from nsswitch
    getent group
    getent networks
    getent services

## Login scripts

Login shells (`su -l`) vs non login shells (`su`)

- The login shell is a new login via ssh, console, `su -` or `su -l`
- Non-login shells occur when calling su (no Params) or bash

Login shells run:

1. `/etc/profile`
1. `~/.bash_profile`
1. `~/.bashrc` (called by `~/.bash_profile`)
1. `/etc/bashrc` (called by `~/.bashrc`)

Non login shells run:

1. `~/.bashrc` (called by `~/.bash_profile`)
1. `/etc/bashrc` (called by `~/.bashrc`)

To determine user context:

* `echo $USER`
* `id`
* `whoami`

But some things don’t change over for a non login shell. E.g. $USER won’t change

Logout scripts:

* `~/.bash_logout`

## System login scripts

    cd etc
    ls profile*
    ls bash*

/etc/profile.d/ contains profile scripts

Prompt ($PS1) is set in bashrc 

Don’t set PATH in rc files as it keeps appending each call to bash - set it in profile files

Need to export variables in profile files

## Home directory templates

    ls -A /etc/skel

Holds templates used when a new home dir has been created

## User accounts

    id # current account
    id root

    id -g
    id -G
    id -Gn

### Creating accounts

    sudo useradd fred

    sudo useradd -N jane -g users -G staff

    sudo useradd jim -G staff -s /bin/sh

### Passwords

    sudo passwd jane 

    sudo grep jane /etc/shadow

    echo 'fred:paasword1'| sudo chpasswd

The `chpasswd` is used for batch changes.

#### Shadow 

Shadow file allows passwords to be inaccessible to regular users: `/etc/shadow`

Move passwords in and out of /etc/passwd:

    pwunconv 
    pwconv

#### Password age

To configure the aging details for the `penguin` account:

    chage penguin

Password ageing data is in /etc/shadow

#### Lock an account

To lock an account

    sudo passwd -l penguin

The user’s password will now be prefixed with `!!` in `/etc/shadow`

To unlock

    sudo passwd -u penguin

## User defaults

    less /etc/login.defs

Range of settings available, including password age controls, home fir creation, home umask, password encryption algorithm

Review defaults:

    sudo useradd -D
    sudo cat /etc/default/useradd

Change the default: 

    sudo useradd -Ds /bin/sh

### Modify and delete accounts

    sudo usermod -c “User One” user1

A user can change their shell:

    chsh -l
    chsh -s /bin/sh tux

To delete a user and their home directory:

    sudo userdel -r user1

To clean up files from a deleted user (who had user id 1004):

    sudo find /home -uid 1004 -delete

## Groups

    /etc/group

To change group,  the user can

    newgrp wheel
    # use exit to drop back after creating resources etc

To create a group:
    
    sudo groupadd sales

Group passwords are set in /etc/gshadow but they don’t usually have passwords

### Membership

    id -G
    id -Gn
    id -gn

To modify a user’s group, use usermod

    sudo gpasswd -a fred sales
    sudo gpasswd -M fred,jane sales

Set group admins using gpasswd -A

Group membership changes require users to logout and login

### SGID

    sudo yum install httpd w3m
    sudo systemctl status httpd
    ls -la /var/www/html
    grep apache /etc/group
    sudo chgrp -R apache /var/www
    sudo chmod -R o= /var/www
    
    sudo -i
    cd /var/www
    chmod g+s .
    umask 027
    vi test.html

### Group passwords

Change primary group id, use newgrp sales

Set a group password to allow users to switch to a group they’re not a member of. But this uses a shared password and is silly.










