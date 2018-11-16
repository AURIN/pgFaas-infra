const osm = {
  name: 'osm',
  sourcecode: require('fs').readFileSync('./functions/script-osm.js', 'utf-8'),
  test: {verb: 'knnbusstops', k: 20, y: -22.28, x: 166.6}
};
console.log(JSON.stringify(osm));
