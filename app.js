'use strict';

var apiDir   = '/api';
var _        = require('lodash');
var models   = require('.'+apiDir+'/models');
var ctrls    = require('.'+apiDir+'/controllers');
var compress = require('koa-compress');
var logger   = require('koa-logger');
var mongoose = require('mongoose');
var serve    = require('koa-static');
var router   = require('koa-router');
//var route = require('koa-route');
var koa      = require('koa');
var path     = require('path');
//var config   = require('./config');
var database = require('./config/database');
var log      = require('./lib/log');
var app      = module.exports = koa();


// Logger
app.use(logger());

// Routers
app.use(router(app));

_.each(ctrls, function(obj, ctrlName){
    if ('routes' in obj === false) {
        return;
    }

    log('s', 's', 'Controller ['+ctrlName+'] has following routes:');
    _.each(obj.routes, function(r){
        var method = r.method ? r.method.toLowerCase() : '';

        if (method == 'post') {
            log('s', 'i', 'POST: '+ apiDir+r.route);
            app.post(apiDir+r.route, r.fn);
        } else if (method == 'put') {
            log('s', 'i', 'PUT: '+ apiDir+r.route);
            app.put(apiDir+r.route, r.fn);
        } else {
            log('s', 'i', 'GET: '+ apiDir+r.route);
            app.get(apiDir+r.route, r.fn);
        }
    });
});
//app.get('/home', ctrls.posts.home)
//   .get('/post', ctrls.posts.list)
//   .get('/post/:id', ctrls.posts.fetch)
//   .post('/post', ctrls.posts.create)
//   .put('/post', ctrls.posts.save);


// Serve static files
app.use(serve(path.join(__dirname, 'build')));

// Compress
app.use(compress());

if (!module.parent) {
    log('s', 's', 'listening on port 3000');
    app.listen(3000);

    app.on('error', function(err, ctx){
        log('s', 'e', err);
        //log('s', 'd', ctx.response);
    });
}