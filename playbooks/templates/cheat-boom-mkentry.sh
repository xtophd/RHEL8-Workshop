#!/bin/bash -x

echo "Determining root device..."

eval $(grep -o '\broot=[^ ]*' /proc/cmdline)*

echo "root=${root}"
echo ""

echo "Creating GRUB2 entry..."
if /usr/sbin/lvs -q ${root} ; then \
  boom create --title "Alt Kernel Parms" --rootlv ${root}
else
  boom create --title "Alt Kernel Parms" --root-device ${root}
fi
