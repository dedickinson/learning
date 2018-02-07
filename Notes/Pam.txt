# PAM

Pluggable authentication modules

    ls /etc/pam.d # systems that use pam
    ls /lib64/security
    ls /etc/security

## Create a home directory at login

Can be useful when creating a lot of users at once

    sudo /etc/login.defs

Set CREATE_HOME to no

    rpm -qa| grep oddjob

    systemctl enable oddjobd
    systemctl start oddjobd
    sudo authconfig —enablemkhomedir —update

Find where mkhomedir has been configured

    grep mkhomedir /etc/pam.d
    
## Password policies

    cat /etc/pam.d/system-auth

Find pam_pwquality.so

Check the policy

    less /etc/security/pwquality.conf
    

Check quality of a password, use pwscore

## Limit access to resources

Can configure access to processor time, memory, number of processes etc

    ulimit -a
    ulimit -u
    ulimit -u 10 # max of ten concurrent user processes
    
Admin sets this up in /etc/security/limits.conf. Soft limits can be increased by a user using ulimit but can’t exceed a hard limit.

## Control access time

Pam can be used to restrict hours of access

    cd /etc/pam.d

    sudo vi sshd

Add the line:

    account required pam_time.so

Shared library is in /lib64/security

    cd /etc/security
    sudo vi time.conf

Add a line of

    *;*;fred|bob;Wk0800-1800

Allows fred and bob access between 8am and 6pm



