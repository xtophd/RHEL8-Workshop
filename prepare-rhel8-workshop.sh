#!/bin/bash

## This script is intended to be run:
##     on the control host (ie: workstation)
##     CWD =  ~root/RHEL8-Workshop

myInventory="./config/rhel8-workshop"

if [ ! -e "${myInventory}" ] ; then
    echo "ERROR: Are you in the right directory? Can not find ${myInventory}" ; exit
    exit
fi

time ansible-playbook -i ${myInventory} -f 5 ./playbooks/rhel8-prep-workshop.yml
    
