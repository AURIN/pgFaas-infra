#!/usr/bin/env bash

source configuration.sh; source secrets.sh
source scripts/get-ips.sh ${1}
echo "Master (public): " ${MASTER_IP} "Master (private): " ${PRIVATE_MASTER_IP}
echo "Workers: " ${WORKERS_IP}
echo "DBServer: " ${PGHOST}
