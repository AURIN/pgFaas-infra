#!/usr/bin/env bash
source ./configuration.sh; source secrets.sh;\
./scripts/cmd.sh master\
  "\
    set -x;\
    docker service update --force nginx\
  "

