#!/bin/bash

if grep -q summitdir /etc/fstab ; then
  echo "Entry already exists, please delete before proceeding"
  exit
fi

# Grabs output from a couple of different commands to create an entry for /etc/fstab

echo "# Determining UUID"

UUID = `lsblk -o uuid /stratis/summitpool/summitfs`

echo "# Adding to fstab: "
echo "UUID=${UUID} /summitdir xfs defaults 0 0"

echo "UUID=${UUID} /summitdir xfs defaults 0 0" >> /etc/fstab


#lsblk -o uuid /stratis/summitpool/summitfs | \
#  tr '\n' '=' |  \
#  sed -e 's#=$# /summitdir xfs defaults 0 0\n#' >> /etc/fstab

