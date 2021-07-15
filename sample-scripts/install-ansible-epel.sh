#!/bin/bash

echo "# Enabling Extra Packages for Enterprise Linux (EPEL)"
echo "#"
echo "#   *NOTE*  Not all additional repos are enable (or available), so some"
echo "#           EPEL content may not install due to missing dependencies"
echo "#"
echo "# For more info see: https://fedoraproject.org/wiki/EPEL"
echo ""

yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

echo ""
echo "# Installing 'ansible'"
echo ""

yum install -y ansible

