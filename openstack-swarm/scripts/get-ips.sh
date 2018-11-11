#!/usr/bin/env bash

source ./secrets.sh
source ./configuration.sh

openstack server list -f json > /tmp/a.json
export IPS=`jq --arg STACK ${STACK_NAME} '[.[].Networks | select(test($STACK))]' /tmp/a.json`

export MASTER_IP=`echo ${IPS} | jq '.[] | split("=")[1] | select(contains(" ")) | split(" ")[1] ' | tr '"' ' ' | tr -d " "`
export PRIVATE_MASTER_IP=`ssh ${USER}@${MASTER_IP} ifconfig | grep "10.0.2" | head -1 | tr -s " " | cut -f 2 -d: | cut -f 3 -d\ `
SERVERS_IP=`echo ${IPS} | jq '.[] | split("=")[1] | select(contains(" ") | not)' | tr '\n' ' ' | tr '"' ' ' | tr -s " "`
export SERVERS_IP="${SERVERS_IP} ${PRIVATE_MASTER_IP}"
WORKERS_IP=
for IP in ${SERVERS_IP}; do
    if [ ${IP} != ${PRIVATE_MASTER_IP} ] && [ ${IP} != ${PGHOST} ]
    then
      WORKERS_IP="${WORKERS_IP} ${IP}"
    fi
done

export WORKERS_IP=`echo ${WORKERS_IP} | tr -s " "`
