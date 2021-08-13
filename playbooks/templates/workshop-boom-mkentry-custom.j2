#!/bin/bash

CUSTOM_OPTS="custom_value=true"

# For the workshop, we need to be prepared for 3 possibilities
#   root disk is specified by UUID
#   root disk is a LVM
#   root disk is a block device
#
# This logic appears to work until proven otherwise

echo "Determining root device..."

eval $(grep -o '\broot=[^ ]*' /proc/cmdline)

echo "UUID reduction if necessary..."

if [[ "${root}" =~ ^UUID=(.*) ]] ; then
  rootdev=`blkid -U ${BASH_REMATCH[1]}`
else
  rootdev="${root}"
fi

echo "Creating GRUB2 entry..."

if /usr/sbin/lvs -q ${rootdev} 2>/dev/null ; then

  rootvg=`lvs -o vg_name --noheadings ${rootdev} 2>/dev/null | awk '{print $1}'`
  rootlv=`lvs -o lv_name --noheadings ${rootdev} 2>/dev/null | awk '{print $1}'`

  echo ""
  echo "DEBUG: boom create --title 'RHEL 8 Workshop' --root-lv ${rootvg}/${rootlv} -a ${CUSTOM_OPTS}"
  echo ""

  boom create --title 'RHEL 8 Workshop' --root-lv ${rootvg}/${rootlv} -a "${CUSTOM_OPTS}"

else

  echo ""
  echo "DEBUG: boom create --title 'RHEL 8 Workshop' --root-device ${rootdev} -a ${CUSTOM_OPTS}"
  echo ""

  boom create --title 'RHEL 8 Workshop' --root-device ${rootdev} -a "${CUSTOM_OPTS}"
fi
