## pgFaas - Sample function library

# Requirements

* Node 8.11.x
* cURL
* Connection to a pgFaas instance


# Deployment of sample functions

They assume your are deploying against a pgFaas instance whose URL is
set in the `PGFAAS_URL` environment variable.
 For instance: `export PGFAAS_URL='pgfaas.aurin.org.au'`


## Function to perform simple arithmetic

```bash
./scripts/load-function.sh math
```
```bash
./scripts/test-function.sh math '{"verb":"add","a":3,"b":5}'

```


## Function to compute various Geopatial funcition on OSM data
```bash
./scripts/load-function.sh osm
```
```bash
./scripts/test-function.sh osm '{"verb":"knnbusstops","k":10,"x":18528319,"y":-2544029}'
```


## Function updates

To update functions, just use:
```bash
./scripts/update-function.sh <function name>
