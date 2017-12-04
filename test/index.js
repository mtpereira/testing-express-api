'use strict';

var test = require('tape');
var request = require('supertest');
var app = require('../server');

test('Correct users returned', function (t) {
  request(app)
    .get('/api/users')
    .expect('Content-Type', /json/)
    .expect(200)
    .end(function (err, res) {
      var expectedUsers = ['John', 'Betty', 'Hal', 'Alex'];

      t.error(err, 'No error');
      t.same(res.body, expectedUsers, 'Users as expected');
      t.end();
    });
});

test('Health endpoint returns 200 and no body', function (t) {
  request(app)
    .get('/health')
    .expect(200)
    .end(function (err, res) {
      t.error(err, 'No error');
      t.same(res.body, {}, 'Empty body as expected');
      t.end();
    });
});
