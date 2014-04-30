'use strict';

var mongoose = require('mongoose');
var config   = require('./index');
var log      = require('../lib/log');
var database = mongoose.connection;

// Mongoose
if (config.replication) {
    var hosts  = config.dbHosts.join(',');
    var onOpen = function(db){
        log('s', 'i', 'MongoDB is now opened with following info');
        log('s', 'd', db.hosts);
        log('s', 'd', db.options);
    };

    setTimeout(function(){
        log('s', 'i', 'Connecting to MongoDB...');
    }, 100);
    mongoose.plugin(function(schema) {
        schema.options.safe = {
            j: 1, w: 2, wtimeout: 10000
        };
    });
    mongoose.connect(hosts, 'mydb', config.replOpts);
} else {
    var onOpen = function(db){
        log('d', 'i', 'MongoDB is now opened at host: '+db.host+', port: '+db.port);
        if ('MONGOHQ_URL' in process.env) {
            log('d', 'i', 'MONGOHQ_URL: '+process.env.MONGOHQ_URL);
        }
    };
    mongoose.connect(config.dbHost);
}

database
.on('error', console.error.bind(console, 'connection error:'))
.on('connected', function(){
    log('d', 's', 'Connection successfully connects to the MongoDB');
}).once('open', function(){
    log('d', 'i', 'Connected to all of this connections models');
    onOpen(database);
}).on('disconnected', function(){
    log('d', 'w', 'MongoDB has disconnected');
}).on('error', function(){
    log('d', 'e', 'MongoDB has an error occurred');
});

module.exports = database