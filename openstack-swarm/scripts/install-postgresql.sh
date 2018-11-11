#!/usr/bin/env bash
./scripts/cmd.sh dbserver\
  "set -x;\
    docker pull mdillon/postgis;\
    docker run --detach --publish 5432:5432 mdillon/postgis:latest;\
    curl -XGET 'http://download.geofabrik.de/australia-oceania/new-caledonia-latest.osm.bz2'\
      -o /tmp/new-caledonia-latest.osm.bz2;\
    bzip2 -d /tmp/new-caledonia-latest.osm.bz2\
      PGPASS=postgres ; osm2pgsql -U postgres -H localhost\
      /tmp/new-caledonia-latest.osm\
  "


