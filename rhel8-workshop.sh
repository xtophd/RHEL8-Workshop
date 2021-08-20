#!/bin/bash

## This script is intended to be run:
##     on the control host (ie: workstation)
##     CWD =  ~root/RHEL8-Workshop

myInventory="./config/master-config.yml"
myCredentials="./config/credentials.yml"

if [ ! -e "${myInventory}" ] ; then
    echo "ERROR: Are you in the right directory? Can not find ${myInventory}" ; exit
    exit
fi

if [ -e "${myCredentials}" ] ; then
    askVaultPass="--ask-vault-pass"
else
    askVaultPass=""
fi
    
    
case "$1" in
    "all")
        time  ansible-playbook ${askVaultPass} -i ${myInventory} -f 10  ./playbooks/rhel8-workshop.yml
        ;;

    "appstream"   | \
    "boom"        | \
    "buildah"     | \
    "ebpf"        | \
    "firewalld"   | \
    "nftables"    | \
    "prep"        | \
    "podman"      | \
    "settings"    | \
    "stratis"     | \
    "systemd"     | \
    "tlog"        | \
    "virt"        | \
    "vdo"         | \
    "wayland"     | \
    "webconsole"  | \
    "kpatch")

        time  ansible-playbook  ${askVaultPass} -i ${myInventory} -f 10 --tags $1 ./playbooks/rhel8-workshop.yml
        ;;

    *)
        echo "USAGE: bastion-setup.sh [ all | prep | appstream | boom | buildah | ebpf | firewalld | nftables | podman | settings | stratis | systemd | tlog | virt | vdo | wayland | webconsole | kpatch ]"
        ;;

esac

