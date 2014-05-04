"use strict";

var fs        = require('fs');
var _         = require('lodash');
var mongoose  = require('mongoose');
var lifecycle = require('mongoose-lifecycle');
var log       = require('../../lib/log');

//var upsertDate = require('./plugins/upsertDate');

var appModel = {
    events: function(Model, customEvents) {
        var events = {
            beforeInsert: function(model) {
                if ('created' in model === true && !model.created) {
                    log('d', 'i', 'Mongoose Lifecycle event [beforeInsert] insert new date to the field [created]');
                    model.created = new Date;
                }
                if ('modified' in model === true && !model.modified) {
                    log('d', 'i', 'Mongoose Lifecycle event [beforeInsert] insert new date to the field [modified]');
                    model.modified = new Date;
                }
            },
            afterInsert: function(data) {
                log('d', 'i', 'Mongoose Lifecycle event [afterInsert]');
            },
            beforeUpdate: function(model) {
                log('d', 'd', model);
                if ('created' in model === true) {
                    log('d', 'i', 'Mongoose Lifecycle event [beforeUpdate] remove field value [created]');
                    delete model.created;
                }
                if ('modified' in model === true) {
                    log('d', 'i', 'Mongoose Lifecycle event [beforeUpdate] update new date to the field [modified]');
                    model.modified = new Date;
                }
                if ('_id' in model === true) {
                    log('d', 'i', 'Mongoose Lifecycle event [beforeUpdate] remove field [_id]');
                    delete model._id;
                }
                if ('__v' in model === true) {
                    log('d', 'i', 'Mongoose Lifecycle event [beforeUpdate] remove field [__v]');
                    delete model.__v;
                }
                log('d', 'd', model);
            },
            afterUpdate: function(doc) {
                log('d', 'i', 'Mongoose Lifecycle event [afterUpdate]');
                log('d', 'i', 'The update response from Mongo is:');
                log('d', 'd', doc);
            },
            beforeSave: function(data) {
                log('d', 'i', 'Mongoose Lifecycle event [beforeSave]');
            },
            afterSave: function(data) {
                log('d', 'i', 'Mongoose Lifecycle event [afterSave]');
            },
            beforeRemove: function(data) {
                log('d', 'i', 'Mongoose Lifecycle event [beforeRemove]');
            },
            afterRemove: function(data) {
                log('d', 'i', 'Mongoose Lifecycle event [afterRemove]');
            }
        };

        var modelEvents = events;

        if (customEvents !== null && _.isObject(customEvents)) {
            modelEvents = _.assign({}, events, customEvents);
        }
        _.each(modelEvents, function(fn, eventName) {
            Model.on(eventName, fn);
        });
        return Model;
    },

    methods: function(Schema, customMethods) {
        var methods = {
            lastUpdate: function(model, callback) {
                var flds = '-_id modified';
                var opts = {
                    sort: {
                        modified: -1
                    }
                };
                this.model(model).findOne({}, flds, opts, callback);
            }
        };
        
        var modelMethods = methods;

        if (customMethods !== null && _.isObject(customMethods)) {
            modelMethods = _.assign({}, methods, customMethods);
        }
        _.each(modelMethods, function(fn, name) {
            log('d', 'i', 'Model has method ['+name+']');
            Schema["static"](name, fn);
        });
        //Schema.plugin(upsertDate);
        Schema.plugin(lifecycle);

        return Schema;
    }
};


/*
 Models are automatically loaded once they are declared in the models directory.
 */
fs.readdirSync(__dirname).forEach(function(file) {
    var moduleName = file.substr(0, file.indexOf('.'));

    if (moduleName !== 'index' && moduleName !== 'appModel') {
        var obj = require('./' + moduleName);
        var Schema, Model;

        log('d', 's', 'Model ['+moduleName+'] has initialized');

        if ('Name' in obj && 'Schema' in obj) {
            Schema = obj.Schema;
            if ('Methods' in obj) { // extend model methods
                Schema = appModel.methods(Schema, obj.Methods);
            } else {
                Schema = appModel.methods(Schema);
            }

            Model = mongoose.model(obj.Name, Schema);
            if ('Events' in obj) { // extend model events
                Model = appModel.events(Model, obj.Events);
            } else {
                Model = appModel.events(Model);
            }
            return exports[moduleName] = Model;
        }
    }
});
