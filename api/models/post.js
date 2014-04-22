
var _        = require('lodash');
var mongoose = require('mongoose');
var Mixed    = mongoose.Schema.Types.Mixed;

exports.Name = 'Client';

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
    creation: {
        type: String,
        required: false
    },
    lastUpdate: {
        type: String,
        required: false
    }
});

exports.Events = {
    beforeInsert: function *(data) {},
    afterInsert: function *(data) {}
};

exports.Methods = {
    find: function *(id, callback) {
        return this.model('Post').find({
            _id: id
        }, callback);
    }, // find

    edit: function *(req, callback) {
        var post = yield parse(this);

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
            return callback();
        });
    } // edit
};


/*
 module.exports =
 name: 'Client'
 Schema: Schema
 Event
 */
