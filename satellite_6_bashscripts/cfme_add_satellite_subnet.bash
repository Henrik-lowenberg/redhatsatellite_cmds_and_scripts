#!/bin/bash
# subnet.lst has 2 fields, satelitesubnetid and description
for LINE in $(cat /tmp/cfme_addsubnet.lst);do
  NAME=awk '{print $1}' $LINE
  DESCR=awk '{print $2}' $LINE
  curl --user admin:smartvm \
    -ki -X POST -H "Accept: application/json" \
    -d '{
          "name" : "$NAME",
          "description" : "$DESCR",
          "category" : { "name" : "subnet" }
        }' \
  https://cfmeuinode.example.com/api/tags
done

