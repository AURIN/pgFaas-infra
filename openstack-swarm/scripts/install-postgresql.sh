#!/usr/bin/env bash
source ./configuration.sh; source secrets.sh;\
source ./scripts/get-ips.sh
./scripts/cmd.sh dbserver\
  "set -x;\
   sudo apt-get install -y osm2pgsql osmctools osm2pgrouting;\
   sudo curl -XGET 'http://download.geofabrik.de/${OSM_REGION}/${OSM_DATA}.osm.bz2'\
     -o /mnt/dbvolume/${OSM_DATA}.osm.bz2;\
   sudo bzip2 --decompress /mnt/dbvolume/${OSM_DATA}.osm.bz2;\
   docker pull starefossen/pgrouting:${PGROUTING_VERSION};\
   docker run --detach --publish 5432:5432 starefossen/pgrouting:${PGROUTING_VERSION};\
      PGPASS=postgres ; osm2pgsql -U postgres -H localhost;\
   osm2pgsql -c -d postgres\
      -U postgres\
      -H localhost\
      /mnt/dbvolume/${OSM_DATA}.osm;\
   osm2pgrouting\
      --file /mnt/dbvolume/${OSM_DATA}.osm\
      --dbname postgres\
      --user postgres\
      --password postgres\
      --clean;\
  "









