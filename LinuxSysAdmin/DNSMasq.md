# DNSMasq

Packages:

    yum install dnsmasq syslinux 


    mkdir -p /var/lib/tftpboot/pxelinux/pxelinux.cfg
    cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/pxelinux/

    cp vmlinuz /var/lib/tftpboot/pxelinux/
    cp initrd.img /var/lib/tftpboot/pxelinux/

    # May need this one too:
    # /usr/sbin/semanage fcontext -a -t tftpdir_t "/var/lib/tftpboot(/.*)?"

Simple `/etc/dnsmasq.d/local.conf`

    listen-address=192.168.57.1
    domain=lab.example.com
    dhcp-range=192.168.57.50,192.168.57.150,12h

    enable-tftp
    tftp-root=/var/lib/tftpboot

Check with `dnsmasq --test`

Then:

    firewall-cmd --add-service={dhcp,dns,tftp} --permanent