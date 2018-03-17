# Managing Users and Groups

## Primary files

* `/etc/passwd` - local users
* `/etc/shadow` - local user passwords
* `/etc/group` - local groups
* `/etc/gshadow` - local group passwords

Logout scripts:

* `~/.bash_logout`

## The `/etc/nsswitch.conf` file

The Name Service Switch config file (`/etc/nsswitch.conf`) is part of the
System Security Services Daemon (SSSD). The `getent` command gets entries
from the administrative database:

    getent passwd 
    getent passwd penguin

    # name services:
    grep passwd /etc/nsswitch.conf

    # view databases from nsswitch
    getent group
    getent networks
    getent services

## System login scripts

    cd etc
    ls profile*
    ls bash*

- `/etc/profile.d/` contains profile scripts
- The prompt (`$PS1`) is set in bashrc 
- Don’t set PATH in rc files as it keeps appending each call to bash - set it in profile files
- Need to export variables in profile files

## Home directory templates

    ls -A /etc/skel

Holds templates used when a new home dir has been created


## User accounts

Obtain info about yourself and others:

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

Change the user's comment field:

    sudo usermod -c "Captain Penguin" penguin

A user can change their shell:

    chsh -l
    chsh -s /bin/sh penguin

To delete a user and their home directory:

    sudo userdel -r badpenguin

To clean up files from a deleted user (who had user id 1004):

    sudo find /home -uid 1004 -delete

## Groups

Defined in: `/etc/group`

To change their current group, the user can

    newgrp wheel
    # use exit to drop back after creating resources etc

To create a group:
    
    sudo groupadd sales

Group passwords are set in `/etc/gshadow` but they don’t usually have passwords

### Group membership

    id -G
    id -Gn
    id -gn

To modify a user’s group, use usermod

    sudo gpasswd -a fred sales
    sudo gpasswd -M fred,jane sales

Set group admins using `gpasswd -A`

Group membership changes require users to logout and login.

### SGID - Set Group ID

    newgrp staff
    mkdir testdir
    chmod g+s testdir
    newgrp # change back
    
Running `ls -l` will yield:

    drwxr-sr-x. 2 penguin staff 6 Mar  8 15:27 testdir

Files created in `testdir` will now be allocated to the `staff` group.

### Group passwords

Set a group password to allow users to switch to a group they’re not a member of. But this uses a shared password and is silly.
