"use strict";

var fs        = require('fs');
var _         = require('lodash');
var mongoose  = require('mongoose');
var lifecycle = require('mongoose-lifecycle');

//var upsertDate = require('./plugins/upsertDate');

var appModel = {
    events: function(Model, customEvents) {
        var events = {
            beforeInsert: function(data) {},
            afterInsert: function(data) {},
            beforeUpdate: function(data) {
                if (!this.modified) {
                    return this.modified = new Date;
                }
            },
            afterUpdate: function(data) {},
            beforeSave: function(data) {},
            afterSave: function(data) {},
            beforeRemove: function(data) {},
            afterRemove: function(data) {}
        };
        if (customEvents !== null && _.isObject(customEvents)) {
            _.assign(events, customEvents);
        }
        _.each(events, function(fn, event) {
            Model.on(event, function(data) {
                return fn(data);
            });
        });
        return Model;
    },

    methods: function(Schema, customMethods) {
        var methods = {
            lastUpdate: function(model, callback) {
                return this.model(model).findOne({}, '-_id modified', {
                    sort: {
                        modified: -1
                    }
                }, callback);
            }
        };

        if (customMethods !== null && _.isObject(customMethods)) {
            _.assign(methods, customMethods);
        }
        _.each(methods, function(fn, name) {
            return Schema["static"](name, fn);
        });
        //Schema.plugin(upsertDate);
        Schema.plugin(lifecycle);

        return Schema;
    }
};


/*
 Modules are automatically loaded once they are declared in the controllers directory.
 */
fs.readdirSync(__dirname).forEach(function(file) {
    var moduleName = file.substr(0, file.indexOf('.'));

    if (moduleName !== 'index' && moduleName !== 'appModel') {
        var obj = require('./' + moduleName);
        var Schema, Model;

        console.log('Model ['+moduleName+'] has initialized');

        if ('Name' in obj && 'Schema' in obj) {
            Schema = obj.Schema;
            if ('Methods' in obj) { // extend model method
                Schema = appModel.methods(Schema, obj.Methods);
            }

            Model = mongoose.model(obj.Name, Schema);
            if ('Events' in obj) { // this model has custom event
                Model = appModel.events(Model, obj.Events);
            }
            return exports[moduleName] = Model;
        }
    }
});
