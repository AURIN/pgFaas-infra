#!/usr/bin/env bash
source ./configuration.sh; source secrets.sh;\
source ./scripts/get-ips.sh
./scripts/cmd.sh master\
  "\
    set -x;\
    docker pull ${DOCKER_REGISTRY}/pgfaas-api:${PGFAAS_VERSION};\
    docker pull ${DOCKER_REGISTRY}/pgfaas-node:${PGFAAS_NODE_VERSION};\
    "
./scripts/cmd.sh workers\
  "\
    set -x;\
    docker pull ${DOCKER_REGISTRY}/pgfaas-api:${PGFAAS_VERSION};\
    docker pull ${DOCKER_REGISTRY}/pgfaas-node:${PGFAAS_NODE_VERSION};\
    "

