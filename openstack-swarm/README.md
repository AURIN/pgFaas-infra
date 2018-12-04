# OpenStack-Swarm

## Architecture

* Some (by default three) Virtual Machines that run as Docker Swarm workers  
* One VM that runs as Docker Swarm Master, and act as front-end, hosting:
  * NginX (acting as reverse proxy on port 80)
  * pgFaas API (runs on port 3010)
* One VM that acts as database server, running PostgreSQL, PostGIS and pgRouting, with some Open Street Map data

The cluster has only port 80 open to the outside world, with one endpoint for the pgFaas API, and the other one for pgFaas User Interface.   


## Requirements

* osm2pgsql 0.94.x
* bzip2 1.0.x
* jq 1.5.x
* OpenStack client 3.14.x
* An OpenStack tenancy


## Configuration 

The `configuration.sh` contains environment variables that can to be customized. 
 
The `secrets.sh` contains informaiton that cannot be shared on GitHub, such as:
```bash
export OS_AUTH_TYPE="password"
export OS_USERNAME="<openstack usernamne>"
export OS_PASSWORD="<opestaxck password>"
export OS_AUTH_URL="<keystone url>"
export KEY_NAME="<openstack key pair>"
export POSTGRES_PASSWORD="<postgresql admin password>"
```


## Provision of VMs from OpenStack 

```bash
  source configuration.sh; source secrets.sh;\
    cat configuration.yaml | envsubst > /tmp/a.yaml;\
  openstack stack create \
    --environment /tmp/a.yaml \
    --template stack.yaml ${STACK_NAME}
```

The stack crration can be checked with:
```bash
  openstack stack list
```

The list of nodes and their roles can be views with: 
```bash
  ./scripts/list-servers.sh
```


## Stack configuration 

Mounting of external volume, as NFS, to every node in the stack (using SSH tunnels):
```bash
 ./scripts/mount-volume.sh 
```

Creation of a Docker swarm on the stack (OpenFaas runs on this swarm):
```bash
 ./scripts/create-swarm.sh
```


## Services installation 

Both OpenFaas and pgFaas are deployed on the Docker swarm, while PostgreSQL is
hosted on a differen node.


### OpenFaas

NOTE: OpenFaas is deployed with no authorization in place.
```bash
 ./scripts/install-openfaas.sh
```

    
### PostgreSQL
 
Deplopyment of a Docker container with PostgreSQL/PostGIS, and loading of OpenStreetMap data
```bash
 ./scripts/install-postgresql.sh
```


### Download all pgFaas images

```bash
 ./scripts/pull-images.sh
```


### pgFaas API

```bash
 ./scripts/install-pgfaas-api.sh
```


### pgFaas UI

```bash
 ./scripts/install-pgfaas-ui.sh
```


## Reverse proxy installation

Copy the configuration file to the master after having substituted ebnv variables:
```bash
 ./scripts/set-service-configs.sh
```

It installs NginX with two HTTP endpoitns: `/api` and `/ui`
```bash
 ./scripts/install-nginx.sh
```

TODO: after every re-deployment of the pgFaas API or UI, the NginX service has to be restarted
 on the master node with: 
```bash
 ./scripts/update-nginx.sh
```


## Direct connection to the database 

This could be useful in connection with pgAdmin (point it to `localhost:5433`)
```bash
 ./scripts/create-pg-tunnel.sh
```

To remove the SSH tunnel:
```bash
 ./scripts/remove-pg-tunnel.sh
```


## De-commissioning

Swarm cluster de-commissioning:
```
  source ./scripts/get-ips.sh ${STACK_NAME};\
  ssh ${USER}@${MASTER_IP} -o "StrictHostKeyChecking no" \
    "docker swarm leave --force"
```

OpenStack stack decommissioning:
```
  source configuration.sh; source secrets.sh;\
    echo "y" | openstack stack delete ${STACK_NAME}
```
