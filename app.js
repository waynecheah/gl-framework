'use strict';

var apiDir   = './api';
var posts    = require(apiDir+'/controllers/posts');
var compress = require('koa-compress');
var logger   = require('koa-logger');
var serve    = require('koa-static');
var router   = require('koa-router');
//var route = require('koa-route');
var koa      = require('koa');
var path     = require('path');
var app      = module.exports = koa();

// Logger
app.use(logger());

// Routers
app.use(router(app));

app.get('/home', posts.home)
   .get('/post', posts.list)
   .get('/post/:id', posts.fetch)
   .post('/post', posts.create)
   .put('/post', posts.save);


// Serve static files
app.use(serve(path.join(__dirname, 'build')));

// Compress
app.use(compress());

if (!module.parent) {
    app.listen(3000);
    console.log('listening on port 3000');
}