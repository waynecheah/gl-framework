"use strict";

var _        = require('lodash');
var mongoose = require('mongoose');
var parse    = require('co-body');
var log      = require('../../lib/log');

var Mixed = mongoose.Schema.Types.Mixed;

exports.Name = 'Post';

exports.Schema = mongoose.Schema({
    author: {
        type: String,
        required: true
    },
    title: {
        type: String,
        required: true
    },
    content: {
        type: String,
        required: false
    },
    created: {
        type: String,
        required: false
    },
    modified: {
        type: String,
        required: false
    }
}/*, { versionKey: false }*/);

exports.Events = {
    afterInsert: function (model) {
        log('d', 'i', 'Custom Mongoose Lifecycle event [afterInsert] do nothing now..');
    }
};

exports.Methods = {
    fetch: function (id, callback) {
        this.model('Post').find({
            _id: id
        }, callback);
    }, // fetch

    updateRec: function (id, doc, callback) {
        var that = this;
        this.emit('beforeUpdate', doc);
        this.findByIdAndUpdate(id, { $set:doc, $inc:{__v:1} }, function(err, doc){
            if (!err) that.emit('afterUpdate', doc);
            callback(err, doc);
        });
    }, // updateRec

    edit: function (req, callback) {
        var post = parse(this);

        query = {
            _id: post.id
        };
        update = {
            author: post.author,
            title: post.title,
            content: post.content
        };

        this.update(query, update, function(err, numAffected) {
            if (err) {
                return callback(err);
            }
            if (numAffected === 0) {
                return callback(new Error('Record is not modified'));
            }
            callback();
        });
    } // edit
};


/*
 module.exports =
 name: 'Client'
 Schema: Schema
 Event
 */
