module.exports = {
  add: (sqlexec, req, callback) => {
    return callback(null, {c: req.body.a + req.body.b});
  },
  minus: (sqlexec, req, callback) => {
    return callback(null, {c: req.body.a - req.body.b});
  },
  times: (sqlexec, req, callback) => {
    return callback(null, {c: req.body.a * req.body.b});
  },
  div: (sqlexec, req, callback) => {
    return callback(null, {c: req.body.a / req.body.b});
  },
  mod: (sqlexec, req, callback) => {
    return callback(null, {c: req.body.a % req.body.b});
  }
};
