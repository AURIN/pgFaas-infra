#!/usr/bin/env bash
#  ############### TO DO
source ./configuration.sh; source secrets.sh;\
source ./scripts/get-ips.sh
./scripts/cmd.sh master\
  "\
    set -x;\
    docker pull lmorandini/pgfaas-ui:${PGFAAS_VERSION};\
    docker service update func_gateway --publish-rm ${PGFAAS_PORT};\
    docker service rm pgfaas-api;\
    docker service create --network=func_functions\
      --publish ${PGFAAS_PORT}:${PGFAAS_PORT}\
      --with-registry-auth\
      --name pgfaas-api\
      --env NODE_ENV=production\
      --env OPENFAAS_URL='http://${PRIVATE_MASTER_IP}:${FAAS_PORT}'\
      --env OPENFAAS_AUTH=''\
      --env PGFAAS_LOGLEVEL=debug\
      --env PGFAAS_PORT=${PGFAAS_PORT}\
      --env PGFAAS_IMAGE='lmorandini/pgfaas-api:${PGFAAS_NODE_VERSION}'\
      --env PGHOST=${PGHOST}\
      --env PGPORT=${PGPORT}\
      --env PGDATABASE=postgres\
      --env PGUSER=${PGUSER}\
      --env PGPASSWORD=${PGPASSWORD}\
      --env PGSCHEMA=public\
      lmorandini/pgfaas-api:${PGFAAS_VERSION};\
    "
