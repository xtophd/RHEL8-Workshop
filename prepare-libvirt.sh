#!/bin/bash

##
## NOTE: you must point to the correct inventory and extravars yml
##
##   Take a sample configs from ./sample-configs and 
##   copy it to ./playbooks/config/{master,libvirt}-config.yml
##

myInventory="./config/master-config.yml"
myExtravars="./config/libvirt-config.yml"

## This script is intended to be run:
##     on the libvirt hypervisor node
##     in the project directory
##     EX: CWD == ~root/RHEL8-Workshop

if [[ ! -e "${myInventory}" || ! -e "${myExtravars}" || ! -d "./playbooks" ]] ; then
    echo "ERROR: Are you in the right directory? Can not find ${myInventory} | ${myExtravars} | ./playbooks " ; exit
    exit
fi

##
##
##

case "$1" in
    "all")

        echo "ansible-playbook -i ${myInventory} -e @${myExtravars} -f 10  ./playbooks.deployer-kvm/libvirt.yml"
        time  ansible-playbook -i ${myInventory} -e @${myExtravars} -f 10  ./playbooks.deployer-kvm/libvirt.yml 
        ;;

    "deploy")

        ## deploy is a special tag that only runs deployment plays, not host setup plays

        echo "ansible-playbook -i ${myInventory} -e @${myExtravars} -f 10  --tags $1 ./playbooks.deployer-kvm/libvirt.yml"
        time  ansible-playbook -i ${myInventory} -e @${myExtravars} -f 10  --tags $1 ./playbooks.deployer-kvm/libvirt.yml 
        ;;

    "deploy"     | \
    "undeploy"   | \
    "redeploy"   | \
    "basics"     | \
    "nested"     | \
    "cockpit"    | \
    "network"    | \
    "dns"        | \
    "haproxy"    | \
    "bastion"    | \
    "nodes"      | \
    "postconfig" | \
    "postinstall")

        echo "ansible-playbook -i ${myInventory} -e @${myExtravars} -f 10  --tags $1 ./playbooks.deployer-kvm/libvirt.yml"
        time  ansible-playbook -i ${myInventory} -e @${myExtravars} -f 10  --tags $1 ./playbooks.deployer-kvm/libvirt.yml 
        ;;

    *)
        echo "USAGE: libvirt-setup.sh [ all | basics | nested | cockpit | network | dns | haproxy | bastion | nodes | postconfig | postinstall ]"
        ;;

esac         
