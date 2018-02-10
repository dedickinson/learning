# General Administration

Other docs:

* [Grub](Grub.md)
* [Run levels](RunLevels.md)

## Kernel and Distribution information

* `cat /etc/system-release`
* `lsb_release -d`
* `rpm -qf $(which lsb_release)`
* `uname -r`
* `cat /proc/version`
* `cat /proc/cmdline`
* `lsblk - lists block devices`

## Shutdown commands

* `reboot`
* `halt`
* `poweroff`

To shutdown in 10 mins and present a brief message:

    shutdown -h 10 “Shutting down”

To cancel a shutdown:

    shutdown -c

`/run/nologin` is created to prevent non-root users from logging in 5 mins prior to shutdown

## Messaging users

`write` - messages a single user

`wall` messages all users:

````
cat > message <<END
Multi
Line
Message
END

wall < message
````

## Managing processes


### ps

ps -e
ps aux
ps -e —forest
pstree
ps -f
ps -F
ps -l

### /proc and $$

ls /proc - yields a list of numbered ids that match process ids

$$ holds the current process id