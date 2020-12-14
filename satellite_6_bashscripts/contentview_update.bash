#!/bin/bash

if [ -z "$1" ]; then
  echo "no CV selected"
  exit 2
else
  CVNAME=$1
fi

case $CVNAME in 
  rhel6|rhel7) 
	/bin/hammer -c /etc/vit/hammer.yml content-view publish --organization="ORG" --async --force-yum-metadata-regeneration=true --name "cv-$CVNAME" --description "$(date +"%Y-%m-%d") monthly RHEL update" > /tmp/contentview_update.out 2>&1
  ;;

  *)
        echo "Invalid option: $text. Please specify: rhel6 or rhel7"
	exit 3
  ;;
esac 
