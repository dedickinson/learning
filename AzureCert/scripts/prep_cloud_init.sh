#!/bin/bash

# THIS ISN"T WORKING YET

# See: https://docs.microsoft.com/en-us/azure/virtual-machines/linux/cloudinit-prepare-custom-image

yum update -y
yum install -y cloud-init gdisk epel-release

yum -y clean all
rm -rf /var/cache/yum

cat <<EOF >/etc/cloud/cloud.cfg.d/91-azure_datasource.cfg
datasource_list: [ Azure ]
EOF

cat <<EOF >/etc/cloud/hostnamectl-wrapper.sh
#!/bin/bash -e
if [[ -n $1 ]]; then
    hostnamectl set-hostname $1
else
    hostname
fi
EOF

chmod 0755 /etc/cloud/hostnamectl-wrapper.sh

cat >/etc/cloud/cloud.cfg.d/90-hostnamectl-workaround-azure.cfg <<EOF
# local fix to ensure hostname is registered
datasource:
Azure:
    hostname_bounce:
    hostname_command: /etc/cloud/hostnamectl-wrapper.sh
EOF

cat <<EOF >/etc/cloud/cloud.cfg
users:
    - default

disable_root: 1
ssh_pwauth:   0

mount_default_fields: [~, ~, 'auto', 'defaults,nofail', '0', '2']
resize_rootfs_tmp: /dev
ssh_deletekeys:   0
ssh_genkeytypes:  ~
syslog_fix_perms: ~

cloud_init_modules:
    - disk_setup
    - mounts
    - migrator
    - bootcmd
    - write-files
    - growpart
    - resizefs
    - set_hostname
    - update_hostname
    - update_etc_hosts
    - rsyslog
    - users-groups
    - ssh

cloud_config_modules:
    - mounts
    - locale
    - set-passwords
    - rh_subscription
    - yum-add-repo
    - package-update-upgrade-install
    - timezone
    - puppet
    - chef
    - salt-minion
    - mcollective
    - disable-ec2-metadata
    - runcmd

cloud_final_modules:
    - rightscale_userdata
    - scripts-per-once
    - scripts-per-boot
    - scripts-per-instance
    - scripts-user
    - ssh-authkey-fingerprints
    - keys-to-console
    - phone-home
    - final-message
    - power-state-change

system_info:
    default_user:
        name: centos
        lock_passwd: true
        gecos: Cloud User
        groups: [wheel, adm, systemd-journal]
        sudo: ["ALL=(ALL) NOPASSWD:ALL"]
        shell: /bin/bash
    distro: rhel
    paths:
        cloud_dir: /var/lib/cloud
        templates_dir: /etc/cloud/templates
    ssh_svcname: sshd
EOF

sed -i 's/Provisioning.Enabled=y/Provisioning.Enabled=n/g' /etc/waagent.conf
sed -i 's/Provisioning.UseCloudInit=n/Provisioning.UseCloudInit=y/g' /etc/waagent.conf
sed -i 's/ResourceDisk.Format=y/ResourceDisk.Format=n/g' /etc/waagent.conf
sed -i 's/ResourceDisk.EnableSwap=y/ResourceDisk.EnableSwap=n/g' /etc/waagent.conf

rm -rf /var/lib/cloud/instances/*
rm -rf /var/log/cloud-init*
