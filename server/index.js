'use strict';

var express = require('express');
var app = express();
var users = ['John', 'Betty', 'Hal', 'Alex'];

app.get('/api/users', function (req, res) {
  res.json(users);
});

app.get('/health', function (req, res) {
  res.status(200).end();
});

module.exports = app;
