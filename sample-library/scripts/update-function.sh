#!/usr/bin/env bash
set -x
node ./functions/${1}.js > /tmp/${1}.json
curl -XPUT "http://${PGFAAS_URL}/api/function/namespaces/sample/${1}"\
  --header "Content-Type:application/json"\
  --data @/tmp/${1}.json -vvv
