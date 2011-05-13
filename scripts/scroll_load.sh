#!/bin/bash

module="scrull"
device="scrull"
mode="644"

/sbin/insmod ./$module.ko $* || exit 1

# delete the old node
rm -f /dev/${device}[0-3]

# create the new node
major=$(awk -v module=$module '$2 == module { print $1 }' /proc/devices
mknod /dev/${device}0 c $major 0
mknod /dev/${device}1 c $major 1
mknod /dev/${device}2 c $major 2
mknod /dev/${device}3 c $major 3

# set permission
group="staff"
grep -q '^staff:' /etc/group || group=wheel

chgrp $group /dev/${device}[0-3]
chgrp $mode /dev/${device}[0-3]
