module.exports = {
  isochrone: (sqlexec, req, callback) => {
    sqlexec.query(
      `SELECT ST_AsGeoJSON(
         ST_Transform(
           (ST_Dump(
             ST_Union(
               ST_Buffer(e.the_geom, 200))
             )
           ).geom,
           4326)
         ) AS the_geom
         FROM (SELECT seq, agg_cost, node, edge, w.the_geom AS the_geom
           FROM pgr_drivingDistance(
             'SELECT gid AS id, source, target, length AS cost FROM ways',
                $1::INTEGER, $2::FLOAT8, false) AS r 
                JOIN ways w ON w.gid = r.edge) e`,
      [req.body.node, req.body.distance], (err, result) => {
        if (err) {
          return callback(err, null);
        }
        let geoJson = {
          type: "FeatureCollection", crs: {
            type: "name",
            properties: {
              name: "urn:ogc:def:crs:EPSG::4326"
            }
          }, features: []
        };
        result.rows.forEach((row) => {
          geoJson.features.push({
            type: "Feature",
            geometry: row.the_geom,
            properties: {
              id: req.body.node
            }
          });
        });
        return callback(err, geoJson);
      }
    );
  }
};
