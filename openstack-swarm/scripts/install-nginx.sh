#!/usr/bin/env bash
source ./configuration.sh; source secrets.sh;\
./scripts/cmd.sh master\
  "\
    set -x;\
    docker pull nginx:1.15.6;\
    docker service update func_gateway --publish-rm 80;\
    docker service rm nginx;\
    docker service create --network=func_functions\
      --publish 80:80\
      --with-registry-auth\
      --config source=nginx-pgfaas,target=/etc/nginx/conf.d/default.conf,mode=0440\
      --name nginx\
      nginx:1.15.6;\
    "

