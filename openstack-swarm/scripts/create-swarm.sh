#!/usr/bin/env bash
source scripts/get-ips.sh
ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "${MASTER_IP}"
ssh ${USER}@${MASTER_IP} -o "StrictHostKeyChecking no" \
  "docker swarm leave --force"
ssh ${USER}@${MASTER_IP} -o "StrictHostKeyChecking no" \
  "docker swarm init --advertise-addr ${PRIVATE_MASTER_IP}"
export TOKEN=`ssh ${USER}@${MASTER_IP} -o "StrictHostKeyChecking no" \
  "docker swarm join-token worker --quiet"`

set -x
for IP in ${WORKERS_IP}; do
  ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[localhost]:2000"
  ssh -f ${USER}@${MASTER_IP} -L 2000:${IP}:22 -N
  ssh ${USER}@localhost -p 2000 -o "StrictHostKeyChecking no" \
    "docker swarm leave --force"
  ssh ${USER}@localhost -p 2000 -o "StrictHostKeyChecking no" \
    "docker swarm join --token ${TOKEN} ${PRIVATE_MASTER_IP}:2377"
  TUNNEL_PID=`ps -ef | grep "L 2000" | cut --fields 2 -d \ | sed '/^\s*$/d' | head -1`
  kill ${TUNNEL_PID}
done
