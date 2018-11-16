#!/usr/bin/env bash
source ./configuration.sh; source secrets.sh;\
source ./scripts/get-ips.sh
kill `ps -ef | grep "L 5433" | tr -s ' ' | cut --fields 2 -d \ | head -1`
ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[localhost]:5433"
ssh -o "StrictHostKeyChecking no" -f ${USER}@${MASTER_IP} -L 2000:${PGHOST}:22 -N

