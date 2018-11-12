#!/usr/bin/env bash
echo INPUT: ${2}
res=`curl -XPOST "http://${PGFAAS_URL}/api/function/namespaces/sample/${1}"\
  --header "Content-Type:application/json"\
  --data ${2}`
echo OUTPUT: ${res}


