# Mail

## Install Postfix

    yum install postfix

    systemctl enable postfix
    systemctl start postfix

Service runs on port 25.

## Configure

Log: `/var/log/maillog`

Configuration file: `/etc/postfix/main.cf`

    postconf # display all config
    postconf -n # display non-defaults

Open `/etc/postfix/main.cf` and take a look. First, back it it

    cp main.cf main.cf.$(date +%F)

Use postfix to configure settings

    postconf -e inet_protocols=ipv4
    postconf -e inet_interfaces=all

    systemctl restart postfix

    netstat -ltn

## Configure DMX records

Edit zone file for domain (eg lab.named)

    lab.example.com. MX 10 mail.lab.example.com

Restart named and check with `dig`

Configure postfix

    postconf -e 'mydestination=localhost,$mydomain'

    postconf -e ‘myorigin=$mydomain’

    postfix check

    systemctl restart postfix

# SMTP Relay

On client systems:

    postconf -e inet_protocols=ipv4
    postconf -e inet_interfaces=all
    postconf -e relayhost=mail.lab.example.com

    postfix check

    systemctl restart postfix

Install `mailx` on clients for testing.

On the mail server

    postconf mynetworks # these can route mail through this server

## Dovecot IMAP/POP3 server

    yum install dovecot

    cd /etc/dovecot

    vi dovecot.conf

Enable protocols and listen elements in `/etc/dovecot/conf.d`

1. Edit `auth.conf`
````    
disable_plaintext_auth = no
auth_mechanisms = plain login
````
1. Edit `mail.conf`
````
mail_access_groups = mail
````
1. Edit `master.conf`
````
unix_listener /var/spool/postfix/private/auth {
    mode = 0667
    user= postfix
    group = postfix
}
````    

Note: Edit `10-ssl.conf` to configure SSL.

Start the service:

    systemctl start dovecot

## The Mutt client

    yum install mutt

To connect to another system, create ~/.muttrc with

    set spoolfile=“imap://user@mail.lab.example.com”

Then run `mutt`

## Email aliases

Check `/etc/aliases`

Run `newaliases` when changed.

