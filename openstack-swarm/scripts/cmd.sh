#!/usr/bin/env bash

display_usage() {
	echo -e "\nUsage:\n (servers|master|workers|dbserver) <cmd>\n"
	}
if [ $# -lt 2 ]
  then
    display_usage
    exit 1
fi

source ./configuration.sh
source secrets.sh;
source ./scripts/get-ips.sh
kill `ps -ef | grep "L 2000" | tr -s ' ' | cut --fields 2 -d \ | sed '/^\s*$/d' | head -1`

case ${1} in
  servers)
    IPS=${SERVERS_IP}
    ;;
  master)
    IPS=${MASTER_IP}
    ;;
  workers)
    IPS=${WORKERS_IP}
    ;;
  dbserver)
    IPS=${PGHOST}
    ;;
esac

for IP in ${IPS}; do
     ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[localhost]:2000"
     echo "Executing command on " ${IP}
     ssh -f ${USER}@${MASTER_IP} -L 2000:${IP}:22 -N
     ssh ${USER}@localhost -p 2000 -o "StrictHostKeyChecking no" "${2}"
     kill `ps -ef | grep "L 2000" | tr -s ' ' | cut --fields 2 -d \ | sed '/^\s*$/d' | head -1`
done
