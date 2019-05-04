#!/bin/bash

echo "# Cleaning up local container images"
podman rmi --all

echo "# Downloading containers images (.tar) from http://core.example.com"

for IMAGENAME in rhel7.5 httpd-24-rhel7 ubi ; do

  echo " ## Grabbing: ${IMAGENAME}"
 
  IMAGEID=`wget -O -  http://core.example.com/containers/${IMAGENAME}.tar | podman load | grep "Loaded image" | cut -f2 -d@`

  echo " ## Tagging: ${IMAGESID} with name ${IMAGENAME}"

  podman tag ${IMAGEID} core.example.com:5000/${IMAGENAME}

  echo "## Pushing image to registry on core.example.com"

  podman push core.example.com:5000/${IMAGENAME}
  
done

echo "# Cleaning up local container images"
podman rmi --all

echo "#"
echo "#Done!"
