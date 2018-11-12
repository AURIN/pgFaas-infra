const math = {
  name: 'math',
  sourcecode: require('fs').readFileSync('./functions/script-math.js', 'utf-8'),
  test: {verb: 'add', a: 1, b: 2}
};
console.log(JSON.stringify(math));
