#!/usr/bin/env bash
./scripts/cmd.sh master\
  "set -x; if ! [ -d faas ]; then git clone https://github.com/openfaas/faas; fi;\
   if ! [ -x "$(command -v faas-cli)" ]; then curl -sSL https://cli.openfaas.com | sudo sh; fi;\
   cd faas; ./deploy_stack.sh --no-auth;\
  "

