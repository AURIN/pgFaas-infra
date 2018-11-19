#!/usr/bin/env bash
source ./configuration.sh; source secrets.sh;\
source ./scripts/get-ips.sh
set -x
cat gateway.nginx | envsubst '${PRIVATE_MASTER_IP} ${PGFAASUI_PORT} ${PGFAAS_PORT} ${PROXY_TIMEOUT}' > /tmp/gateway.nginx
scp /tmp/gateway.nginx ${USER}@${MASTER_IP}:/tmp
./scripts/cmd.sh master\
  "\
    set -x;\
    docker service rm nginx;\
    docker config rm nginx-pgfaas;\
    docker config create nginx-pgfaas /tmp/gateway.nginx\
  "

