#!/usr/bin/env bash
curl -XGET "http://${PGFAAS_URL}/api/function/namespaces/sample/${1}"\
  --header "Content-Type:application/json"


