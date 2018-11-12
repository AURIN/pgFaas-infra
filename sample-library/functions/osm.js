const osm = {
  name: 'osm',
  sourcecode: require('fs').readFileSync('./functions/script-osm.js', 'utf-8'),
  test: {verb: 'knnbusstops', k: 20, y: -2544122, x: 18528107}
};
console.log(JSON.stringify(osm));
