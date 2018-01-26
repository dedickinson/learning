# Run levels

## Change run levels (targets)

To see the current run level: 

* who -r
* runlevel

Change default run level:
systemctl get-default
systemctl set-default multi-user.target

Change current run level: 

* systemctl isolate multi-user.target
* systemctl isolate rescue.target

Boot to Rescue.Target:

* Edit (e) default entry in grub
* At the end of the ‘linux16’ line, add systemd.unit=rescue.target
* login as root user
