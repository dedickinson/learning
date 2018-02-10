# Date and time

Basic commands:

* `date`
* `date +"%Y-%m-%d %H:%M"` - formatted date
* `hwclock`
* `timedatectl` - comprehensive date-time info

## timedatectl

To list known timezones:

    timedatectl list-timezones

And to set the timezone:

    timedatectl set-timezone time_zone

See [RHEL 7 SysAdmin Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/chap-configuring_the_date_and_time#sect-Configuring_the_Date_and_Time-timedatectl-Time_Zone)

## Chrony

Check which packages are installed:

    rpm -qi ntp
    rpm -qi chrony

I'll use `chrony` rather than `ntp`:

    sudo yum install -y chrony
    sudo systemctl enable chronyd
    sudo systemctl start chronyd

Check the [RHEL 7 Admin Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-configuring_ntp_using_the_chrony_suite#sect-Introduction_to_the_chrony_Suite) for a discussion regarding chrony vs. ntp.

Configuration is in `/etc/chrony.conf` and the `chronyc` utility is
used to configure the service.

To check if chrony is synchonised:

    chronyc tracking

The time sources are listed by:

    chronyc sources

