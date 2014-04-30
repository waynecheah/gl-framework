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
var config   = require('../../config');
var log      = require('../../lib/log');

var webPort  = config.webPort ? ':'+config.webPort : '';
var host     = 'http://localhost'+config.webPort;
var Post     = mongoose.model('Post');


var Posts = {
    home: function *() {
        // render html body
        this.type = 'text/html';
        this.body = '<h1>This is Post page</h1>';
    }, // home

    list: function *() {
        var posts = function(cb){
            Post.find({}, function(err, doc){
                cb(err, doc);
            });
        };
        this.set('Access-Control-Allow-Origin', host);
        this.body = yield posts;
    }, // list

    fetch: function *(id) {
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
        this.set('Access-Control-Allow-Origin', host);

        var post = parse(this);
        var num  = sample.length + 1;
        var date = (new Date).toLocaleString();

        post._id        = num;
        post.creation   = date;
        post.lastUpdate = date;
        sample.push(post);

        this.body = post;
    }, // create

    save: function *() {
        this.set('Access-Control-Allow-Origin', host);

        var post = parse(this);
        var date = (new Date).toLocaleString();

        //post._id        = num;
        post.lastUpdate = date;
    
        this.body = post;
    } // save
};

Posts.routes =  [
    { route:'/home', fn:Posts.home },
    { route:'/post', fn:Posts.list },
    { route:'/post/:id', fn:Posts.fetch },
    { method:'post', route:'/post', fn:Posts.create },
    { method:'put', route:'/post', fn:Posts.save }
];
//route.get('Posts.home', '/post').action(Posts.home);
//route.get('Posts.list', '/posts').action(Posts.list);
//route.get('Posts.fetch', '/post/:id').action(Posts.fetch);

module.exports = Posts;