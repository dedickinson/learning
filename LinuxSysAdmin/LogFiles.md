# Log files

## Auditing logins

As root, use `lastlog` to list last logins. To view only users that have logged in:

    lastlog | grep -v Never

The `last` command lists the last logins. `last -n 10` to limit entries

To view reboots:

    last reboot

For a user:

    last ansible

Data is from `/var/log/wtmp` (binary)

Bad logins:

    sudo lastb

Data is from `/var/log/btmp` (binary)

## Auditing root access

Audits use of the su and sudo commands.

    cat /var/log/secure

    grep secure /var/log/secure
    grep su: /var/log/secure

The logs show the call to sudo or su but not the commands run in the su session

## Using awk to analyse logs

File: `/var/log/secure`

    awk '/sudo/ { print $0 }' /var/log/secure

    awk '/sudo/ { print $5, $6 }' /var/log/secure

Create a script (`secure.sh`) containing:

    #!/usr/bin/bash
    awk "/$1/ { print \$5,\$6,\$14 }" $2

Set the script to executable and run:

    ./secure.sh sudo /var/log/secure


## Configure logging

Key log config:

    /etc/rsyslog.conf
    /etc/rsyslog.d

Some rules log to files, some to modules

Need to restart `rsyslog` after config changes

    systemctl restart rsyslog

The logger command can be used to send a log message

    logger -p local1.warn “Test message”

Check `/var/log/messages` but can also configure `local1` messages to also go to their own file.

## Log rotate

Configuration: `/etc/logrotate.conf`

Runs daily under `/etc/cron.daily/logrotate`

Can add an entry in conf or in a `logrotate.d\` file

Can run `logrotate` ad-hoc

    logrotate /etc/logrotate.conf

## Journalctl

A facility for querying the systemd journal.

Check the service:

    systemctl status systemd-journald

Some interesting commands:

    journalctl
    journalctl -n
    journalctl -n 20
    journalctl -f # Follow

    journalctl -u sshd.service

    journalctl --since=2016-01-21
    journalctl --since="10 minutes ago"

    journalctl --priority=alert

    journalctl --list-boots
    journalctl -b -1 #for the previous boot

Entries are in memory so reset on reboot

Config: `/etc/systemd/journals.conf`

Can be set to send to a log file - reconfig needs a reboot.
