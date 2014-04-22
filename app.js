'use strict';

var apiDir   = './api';
var _        = require('lodash');
var models   = require(apiDir+'/models');
var ctrls    = require(apiDir+'/controllers');
var compress = require('koa-compress');
var logger   = require('koa-logger');
var mongoose = require('mongoose');
var serve    = require('koa-static');
var router   = require('koa-router');
//var route = require('koa-route');
var koa      = require('koa');
var path     = require('path');
var config   = require('./config');
var log      = require('./lib/log');
var app      = module.exports = koa();

// Mongoose
if (config.replication) {
    var hosts = config.dbHosts.join(',');
    var opts  = {
        db: { native_parser: false },
        server: { auto_reconnect: true },
        replset: { rs_name: 'replicationName' }
        //user: '',
        //pass: ''
    };
    var onOpen = function(db){
        log('s', 'i', 'MongoDB is now opened with following info');
        log('s', 'd', db.hosts);
        log('s', 'd', db.options);
    };

    mongoose.plugin(function(schema) {
        schema.options.safe = {
            j: 1, w: 2, wtimeout: 10000
        };
    });
    mongoose.connect(hosts, 'mydb', opts);
    setTimeout(function(){
        log('s', 'i', 'Connecting to MongoDB...');
    }, 100);
} else {
    var onOpen = function(db){
        log('d', 'i', 'MongoDB is now opened at host: '+db.host+', port: '+db.port);

        var Post = mongoose.model('Post');
        Post.findOne({}, {}, function(err, doc){
            log('d', 'd', doc);
        });

        if ('MONGOHQ_URL' in process.env) {
            log('d', 'i', 'MONGOHQ_URL: '+process.env.MONGOHQ_URL);
        }
    };
    mongoose.connect(config.dbHost);
}

var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'))
.on('connected', function(){
    log('d', 's', 'Connection successfully connects to the MongoDB');
}).once('open', function(){
    log('d', 'i', 'Connected to all of this connections models');
    onOpen(db);
}).on('disconnected', function(){
    log('d', 'w', 'MongoDB has disconnected');
}).on('error', function(){
    log('d', 'e', 'MongoDB has an error occurred');
});

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
            log('s', 'i', 'POST: '+ r.route);
            app.post(r.route, r.fn);
        } else if (method == 'put') {
            log('s', 'i', 'PUT: '+ r.route);
            app.put(r.route, r.fn);
        } else {
            log('s', 'i', 'GET: '+ r.route);
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
    log('s', 's', 'listening on port 3000');
}