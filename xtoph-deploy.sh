#!/bin/bash

##
## NOTE: you must point to the correct inventory and extravars yml
##
##   Take a sample configs from ./sample-configs and 
##   copy it to ./playbooks/config/{master,libvirt}-config.yml
##

myInventory="./config/master-config.yml"

if [[ ! -e "${myInventory}" || ! -e "./xtoph-deploy.yml" ]] ; then
    echo "ERROR: Are you in the right directory? Can not find ${myInventory} | xtoph-deploy.yml" ; exit
    exit
fi

##
##
##

case "$1" in
    "")

        time  ansible-playbook --ask-vault-pass -i ${myInventory} -f 10 xtoph-deploy.yml
        ;;

    "deploy"     | \
    "undeploy"   | \
    "redeploy"   | \
    "workshop"   | \
    "setup")

        time  ansible-playbook --ask-vault-pass -i ${myInventory} -f 10 -e xtoph_deploy_cmd=${1} xtoph-deploy.yml
        ;;

    *)
        echo "USAGE: xtoph-deploy.sh [ all | setup | deploy | undeploy | redeploy | finish | workshop ]"
        ;;

esac         
