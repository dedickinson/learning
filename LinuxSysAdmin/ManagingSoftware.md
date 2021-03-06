# Managing software

## Using RPMS

    yum install httpd # select d to download only

    tree /var/cache/yum

    cd /var/cache/yum/x84_64/7/base/packages/

List all packages currently installed:

    rpm -qa

Query a package:

    rpm -qi nmap

    rpm -qpl httpd...

To install: `rpm -i x.rpm`

To remove: `rpm -e nmap`

To query the source package of a file

    rpm -qf /etc/hosts

To verify a package

    rpm -V nmap

## YUM

A handy package to have:

    yum install bash-completion

Check dependencies

    yum depmap httpd

List installed

    yum list installed

List available

    yum list available

### Configure repositories

    /etc/yum.repos.d

    yum repolist

    yum repolist all

Can create a local repo by hosting the CD files behind a web server. Then configure a repo with the baseurl. 

### YUM cache

    tree /var/cache/yum

    yum makecache

    yum clean all

## Kernel updates

    uname -r

To update the kernel

    yum update kernel

Kernels are really installed, not updated - it keeps the old kernel

To exclude kernels from updates, edit /etc/yum.conf and add the line:

    exclude=kernel*

## Source RPMs

Todo: Run through this on lab system.

    /etc/yum.repos.d/Centos-Sources.repo

    sed -i ‘s/^enabled=0/enabled=1/‘ Centos-Sources.repo

    yum install -y yum-utils

    yumdownloader —source zsh

    yum install ncurses-devel

    rpm -i zsh.rpm

    cd rpmbuild/SOURCES

    tar -xjf zsh.tar.bz2

    cd zsh...

    ./configure

    make

    make install
    
## Enabling services

Yum installs the service (eg httpd) but it needs to be started and enabled:

    systemctl status httpd.service
    systemctl enable httpd.service
    systemctl start httpd.service

## Configuration management with Puppet

    yum install puppet # needs epel
    puppet —version

    facter
    facter | grep hostname
    
### Puppet manifests

    /etc/puppet

    mkdir -p /etc/puppet/manifests
    cd /etc/puppet/manifests
    vim site.pp

    # Prepare manifest

    puppet apply site.pp






