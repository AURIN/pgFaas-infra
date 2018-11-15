#!/usr/bin/env bash
export OSM_REGION='australia-oceania'
export OSM_DATA='new-caledonia-latest'
export VERSION='latest'
./scripts/cmd.sh dbserver\
  "set -x;\
    docker pull starefossen/pgrouting:${VERSION};\
    docker run --detach --publish 5432:5432 starefossen/pgrouting:${VERSION};\
    curl -XGET 'http://download.geofabrik.de/${OSM_REGION}/${OSM_DATA}.osm.bz2'\
      -o /tmp/${OSM_DATA}-latest.osm.bz2;\
    bzip2 -d /tmp/${OSM_DATA}.osm.bz2\
      PGPASS=postgres ; osm2pgsql -U postgres -H localhost\
      /tmp/${OSM_DATA}.osm;\
    sudo apt-get install -y osm2pgrouting;\
    osm2pgrouting\
      --file /tmp/${OSM_DATA}.osm\
      --dbname postgres\
      --user postgres\
      --password postgres\
      --clean;\
  "
