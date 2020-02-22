#!/bin/bash

## This script is designed to quickly take care of temporarily 
## registering this client to rhsm for the purposes of installing 
## ansible.  It unregisters are the completion of the script

subscription-manager register

subscription-manager attach

subscription-manager repos --disable=*

subscription-manager repos --enable=ansible-2.9-for-rhel-8-x86_64-rpms

yum install -y ansible

subscription-manager clean


