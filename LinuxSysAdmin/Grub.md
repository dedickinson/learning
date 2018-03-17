# GRUB

To reinstall: `grub2-install /dev/sda`

## Using grubby

    grubby —default-kernel
    grubby —set-default /boot/<kernel>
    grubby —info=all
    grubby —info /boot/<kernel>
    grubby —remove-args=“rhgb quiet” —update-kernel /boot/<kernel>

## GRUB2 defaults

    vi /etc/default/grub
    grub2-mkconfig /boot/grub2/grub.cfg
    reboot

## Manage GRUB recovery

* vi /etc/default/grub
* GRUB_DISABLE_RECOVERY=“false”
* save and exit
* grub2-mkconfig -o /boot/grub2/grub.cfg
* reboot
* grub menu now includes recovery mode options


## Recover from lost root passwords

* in grub boot, select kernel entry and edit
* remove ‘rhgb’ and ‘q’, add ‘rd.break’ and ‘enforcing=0’ (for SELinux)
* save and start
* at the prompt, 
    * ‘mount -o remount,rw /sysroot’
    * chroot /sysroot
    * passwd
 * restart and login
* restorecon /etc/shadow
* setenforce 1


## Password protect GRUB

* vi /etc/grub.d/01_users

set superusers “duncan”
password duncan L1nux

Then mkconfig and reboot

If you try to edit the menu at boot, you’ll need a password

To encrypt a password:

    grub2-mkpasswd-pbkdf2

Copy the hashed password and edit the users file:

set superusers “duncan”
password_pbkdf2 duncan <hash>


## Custom GRUB2 entries

/etc/grub.d/40_custom

Add in custom entry

Then grub2_mkconfig and reboot