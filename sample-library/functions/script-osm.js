module.exports = {
  cliprect: (sqlexec, req, callback) => {
    sqlexec.query(
      `SELECT 
          osm_id AS id, ST_AsGeoJSON(ST_Intersection(way, ST_MakeEnvelope($1, $2, $3, $4, 3857)))::json AS geom
        FROM planet_osm_roads
        WHERE way && ST_MakeEnvelope($1, $2, $3, $4, 3857)`,
      req.body.bbox, (err, result) => {
        if (err) {
          return callback(err, null);
        }
        let geoJson = {
          type: "FeatureCollection", crs: {
            type: "name",
            properties: {
              name: "urn:ogc:def:crs:EPSG::3857"
            }
          }, features: []
        };
        result.rows.forEach((row) => {
          if (row.geom.type !== "GeometryCollection") {
            geoJson.features.push({
              type: "Feature",
              geometry: row.geom,
              properties: {
                id: row.id
              }
            });
          }
        });
        return callback(err, geoJson);
      }
    );
  },
  knnbusstops: (sqlexec, req, callback) => {
    sqlexec.query(
      `SELECT ST_AsGeoJSON(ST_Transform(way, 4326)) AS geom, name, osm_id AS id, operator,
         ST_Distance(ST_Transform(way, 4326), ST_SetSRID(ST_MakePoint($2, $3), 4326)) AS distance
         FROM planet_osm_point
         WHERE highway = 'bus_stop'
         ORDER BY distance LIMIT $1`,
      [req.body.k, req.body.x, req.body.y], (err, result) => {
        if (err) {
          return callback(err, null);
        }
        let geoJson = {
          type: "FeatureCollection", crs: {
            type: "name",
            properties: {
              name: "urn:ogc:def:crs:EPSG::3857"
            }
          }, features: []
        };
        result.rows.forEach((row) => {
          if (row.geom.type !== "GeometryCollection") {
            geoJson.features.push({
              type: "Feature",
              geometry: JSON.parse(row.geom),
              properties: {
                id: row.id,
                name: row.name,
                operator: row.operator
              }
            });
          }
        });
        return callback(err, geoJson);
      }
    );
  },
  shortestpath: (sqlexec, req, callback) => {
    sqlexec.query(
      `SELECT St_AsGeoJSON(w.the_geom) as geom, w.gid AS id, p.seq as seq, p.agg_cost
    FROM ways w INNER JOIN 
       (SELECT * FROM pgr_dijkstra(
         'SELECT gid AS id, source, target, length AS cost FROM ways',
         $1::INTEGER, $2::INTEGER, directed := false)
       ) p ON w.gid = p.edge`,
      [req.body.start, req.body.end], (err, result) => {
        if (err) {
          return callback(err, null);
        }
        let geoJson = {
          type: "FeatureCollection", crs: {
            type: "name",
            properties: {
              name: "urn:ogc:def:crs:EPSG::3857"
            }
          }, features: []
        };
        result.rows.forEach((row) => {
          if (row.geom.type !== "GeometryCollection") {
            geoJson.features.push({
              type: "Feature",
              geometry: JSON.parse(row.geom),
              properties: {
                id: row.id,
                seq: row.seq,
                agg_cost: row.agg_cost
              }
            });
          }
        });
        return callback(err, geoJson);
      }
    );
  }
};
