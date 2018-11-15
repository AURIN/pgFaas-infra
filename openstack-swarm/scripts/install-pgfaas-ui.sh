#!/usr/bin/env bash
source ./configuration.sh; source secrets.sh;\
source ./scripts/get-ips.sh
./scripts/cmd.sh master\
  "\
    set -x;\
    docker service update func_gateway --publish-rm ${PGFAASUI_PORT};\
    docker service rm pgfaas-ui;\
    docker service create --network=func_functions\
      --publish ${PGFAASUI_PORT}:${PGFAASUI_PORT}\
      --with-registry-auth\
      --name pgfaas-ui\
      --env NODE_ENV=sandbox\
      --env EXPRESS_PORT=${PGFAASUI_PORT}\
      --env PGFAAS_API_URL='http://pgfaas.aurin.org.au/api'\
      --env BIND_ADDRESS='0.0.0.0'\
      lmorandini/pgfaas-ui:${PGFAASUI_VERSION};\
    "
