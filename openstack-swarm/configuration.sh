#!/usr/bin/env bash

# OpenStaclk stack name
export STACK_NAME=pgfs
#export STACK_NAME=pgfb

# pgFaas base image
export PGFAAS_NODE_VERSION="latest"

# pgFaaas API general configuration
export PGFAAS_VERSION="latest"
export FAAS_PORT=8080
export PGFAAS_PORT=3010
export PGFAASUI_VERSION="latest"
export PGFAASUI_PORT=3020
export PGFAASAPI_REPLICAS=3

# Timeout in seconds (it should be the longest expected wait for a
# funciton to complete)
export PROXY_TIMEOUT=300

# phFaas API URL\
export PGFAAS_API_URL="http://sandbox.pgfaas.aurin.org.au/api"

# OpenStack tenancy parameters
export OS_PROJECT_NAME="BigTwitter"
export OS_USER_DOMAIN_NAME="Default"
export OS_REGION_NAME="Melbourne"
export OS_INTERFACE="public"
export OS_IDENTITY_API_VERSION=3

export DOCKER_REGISTRY=lmorandini

# VM image and flavour (these depend on the OpenStack cloud you are deployong on)
export SERVER_IMAGE="e574cad1-b653-4166-9ece-7596d2d66d35"
export SERVER_FLAVOR="m1.medium"

# OpenStack default VM user
export USER=ubuntu

# Number of Swarm workers
export WORKERS_COUNT=3

# OpenStack network
export EXTERNAL_NETWORK="melbourne"

# External volume mount point, size and Availability Zone
export DB_FILESYSTEM=/mnt/dbvolume
export DB_VOLUME_SIZE=250
export DB_VOLUME_AZ=melbourne-qh2

# Database server parameters, with username/password of the PostgreSQL
# user that execute pgFaas functions (this user should be limited to a schema
# in a database and to read-only)
export PGHOST="10.0.2.27"
export PGPORT=5432
export PGDATABASE=postgres
export PGUSER=postgres
export PGPASSWORD=postgres

# OpenStreetMap data
export OSM_REGION='australia-oceania'
export OSM_DATA='new-caledonia-latest'
export PGROUTING_VERSION='latest'
