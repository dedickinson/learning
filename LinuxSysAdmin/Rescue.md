# Rescuing a broken boot

If available, choose the Rescue option in Grub. If not, in the Grub menu, press `e` and launch into the emergency target by adding the following to the kernel call

  systemd.unit=emergency.target
  
To edit anything, log in as root and run:

  mount -o remount,rw /
