#!/usr/bin/env bash

source scripts/get-ips.sh ${STACK_NAME}
kill `ps -ef | grep "L 2000" | tr -s ' ' | cut --fields 2 -d \ | head -1`

for IP in ${SERVERS_IP}; do
    if [ ${IP} != ${PRIVATE_MASTER_IP} ]
    then
      ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[localhost]:2000"
      echo "Executing command on " ${IP}
      ssh -f ${USER}@${MASTER_IP} -L 2000:${IP}:22 -N
      ssh ${USER}@localhost -p 2000 -o "StrictHostKeyChecking no" \
        "sudo mkdir ${DB_FILESYSTEM}; sudo mount -t nfs ${PRIVATE_MASTER_IP}:${DB_FILESYSTEM} ${DB_FILESYSTEM}; df -h"
      kill `ps -ef | grep "L 2000" | tr -s ' ' | cut --fields 2 -d \ | head -1`
    fi
done
