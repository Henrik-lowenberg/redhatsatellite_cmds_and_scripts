#!/bin/bash
if [ $(id -u) != "0" ]; then
  sudo "$0" "$@"
  exit $?
fi

declare -A subscription_id_arr
SCRIPTNAME=$(basename "$0")
# Clear log file
[[ -f "files/$SCRIPTNAME.log" ]] && > "files/$SCRIPTNAME.log"
hammer -c /etc/vit/hammer.yml subscription list --organization-id 1 |grep "Red Hat"|awk '{print $1}' > "files/$SCRIPTNAME.tmp"
z=0
while read line
do
  subscription_id_arr[$z]=$line
  z=$(expr $z +1)
done < files/$SCRIPTNAME.tmp
# Loop through all Red Hat subscriptions
for i in "${subscription_id_arr[@]}"
do
#  curl -k -u sat6user:changeme -X GET https://sat6host.some.domain/katello/api/subscriptions/$i|json_reformat >> files/$SCRIPTNAME.log
echo $i
done
