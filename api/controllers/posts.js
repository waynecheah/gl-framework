'use strict';

var sample = [{
    _id: 1,
    author: 'Wayne Cheah',
    title: 'Hello World',
    content: 'some content at here',
    creation: '2014-04-08 12:35:32',
    lastUpdate: '2014-04-08 12:35:32'
}, {
    _id: 2,
    author: 'Cheah Kok Weng',
    title: 'Foo and Bar',
    content: 'Show foo bar content at here',
    creation: '2014-04-09 10:51:12',
    lastUpdate: '2014-04-09 10:51:12'
}];
var mongoose = require('mongoose');
var parse    = require('co-body');
var config   = require('../../config');
var log      = require('../../lib/log');

var webPort  = config.webPort ? ':'+config.webPort : '';
var host     = 'http://localhost'+webPort;
var Post     = mongoose.model('Post');


var Posts = {
    home: function *() {
        // render html body
        this.type = 'text/html';
        this.body = '<h1>This is Post page</h1>';
    }, // home

    list: function *() {
        var posts = function(cb){
            Post.find({}, '-__v', function(err, doc){
                cb(err, doc);
            });
        };
        this.body = yield posts;
    }, // list

    fetch: function *(next) {
        log('d', 'd', this.params.id);
        var post = function(cb){
            Post.fetch(id, function(err, doc){
                cb(err, doc);
            });
        };
        var post = sample[1];
        
        if (!post) {
            this.throw(404, 'post with id = ' + id + ' was not found');
        }
        this.body = yield post;
    }, // fetch

    create: function *() {
        var post   = yield parse(this);
        var create = function(cb){
            Post.create(post, function(err, doc){
                cb(err, doc);
            });
        }
        this.body = yield create;
    }, // create

    save: function *() {
        var post = yield parse(this);
        var save = function(cb){
            Post.updateRec(this.params.id, post, cb);
        }
        this.body = yield save;
    }, // save
    
    remove: function *() {
        var id  = this.params.id;
        var del = function(cb){
            Post.findByIdAndRemove(id, function(err, doc){
                log('d', 'd', doc);
                cb(err, doc);
            });
        };
        this.body = yield del;
    } // remove
};

Posts.routes =  [
    { route:'/home', fn:Posts.home },
    { route:'/post', fn:Posts.list },
    { route:'/post/:id', fn:Posts.fetch },
    { method:'post', route:'/post', fn:Posts.create },
    { method:'put', route:'/post/:id', fn:Posts.save },
    { method:'delete', route:'/post/:id', fn:Posts.remove },
    { method:'options', route:'/post' },
    { method:'options', route:'/post/:id' }
];
//route.get('Posts.home', '/post').action(Posts.home);
//route.get('Posts.list', '/posts').action(Posts.list);
//route.get('Posts.fetch', '/post/:id').action(Posts.fetch);

module.exports = Posts;