#!/usr/bin/env bash
set -x
node ./functions/${1}.js > /tmp/${1}.json
curl -XPOST "http://${PGFAAS_URL}/api/function/namespaces/sample"\
  --header "Content-Type:application/json"\
  --data @/tmp/${1}.json -vvv
