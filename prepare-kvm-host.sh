#!/bin/bash

##
## NOTE: you must point to the correct inventory
##
##   Take a sample config from ./configs and 
##   copy it to ./playbooks/vars-custom/master-config.yml
##

myInventory="./config/master-config.yml"

## This script is intended to be run:
##     on the libvirt hypervisor node
##     in the project directory
##     EX: CWD == ~root/OCP4-Workshop

if [ ! -e "${myInventory}" ] ; then
    echo "ERROR: Are you in the right directory? Can not find ${myInventory}" ; exit
    exit
fi

if [ ! -e "./playbooks" ] ; then
    echo "ERROR: Are you in the right directory? Can not find ./playbooks" ; exit
    exit
fi

##
##
##

case "$1" in
    "all")
        time ansible-playbook -i ${myInventory} -f 10 ./playbooks.deployer-kvm/libvirt-setup.yml 

        if $? ; then
          time ansible-playbook -i ${myInventory} -f 10 ./playbooks/libvirt-postinstall.yml 
        fi
        ;;
         
    "basics")
        time ansible-playbook -i ${myInventory} -f 10 ./playbooks.deployer-kvm/libvirt-basics.yml 
        ;;
         
    "cockpit")
        time ansible-playbook -i ${myInventory} -f 10 ./playbooks.deployer-kvm/libvirt-cockpit.yml 
        ;;

    "network")
        time ansible-playbook -i ${myInventory} -f 10 ./playbooks.deployer-kvm/libvirt-network.yml 
        ;;
         
    "dns")
        time ansible-playbook -i ${myInventory} -f 10 ./playbooks.deployer-kvm/libvirt-dns.yml 
        ;;
         
    "bastion")
        time ansible-playbook -i ${myInventory} -f 10 ./playbooks.deployer-kvm/libvirt-create-bastion.yml 
        ;;

    "nodes")
        time ansible-playbook -i ${myInventory} -f 10 ./playbooks.deployer-kvm/libvirt-create-nodes.yml 
        ;;

    "nodeconfig")
        time ansible-playbook -i ${myInventory} -f 10 ./playbooks.deployer-kvm/libvirt-nodeconfig.yml 
        ;;

    "postinstall")
        time ansible-playbook -i ${myInventory} -f 10 ./playbooks/libvirt-postinstall.yml 
        ;;

    *)
        echo "USAGE: libvirt-setup.sh [ all | basics | cockpit | network | dns | bastion | nodes | nodeconfig | postinstall ]"
        ;;

esac         


