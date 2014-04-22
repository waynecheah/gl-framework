'use strict';

var apiDir   = './api';
var _        = require('lodash');
var models   = require(apiDir+'/models');
var ctrls    = require(apiDir+'/controllers');
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

_.each(ctrls, function(obj, ctrlName){
    if ('routes' in obj === false) {
        return;
    }

    console.log('Controller ['+ctrlName+'] has following routes:');
    _.each(obj.routes, function(r){
        var method = r.method ? r.method.toLowerCase() : '';

        if (method == 'post') {
            console.log('POST: '+ r.route);
            app.post(r.route, r.fn);
        } else if (method == 'put') {
            console.log('PUT: '+ r.route);
            app.put(r.route, r.fn);
        } else {
            console.log('GET: '+ r.route);
            app.get(r.route, r.fn);
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
    app.listen(3000);
    console.log('listening on port 3000');
}