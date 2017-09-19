'use strict';
const express = require('express');

module.exports = function(db) {
  const x = express();
  x.get('/:val', (req, res) => db.query(req.body).then((ans) => res.send(ans.rows||[])));
  return x;
};
