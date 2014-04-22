"use strict";

var fs = require('fs');
var _  = require('lodash');

//var appController = require('./appController');
var appController = {
    layout: 'default',

    beforeRender: function *() {},

    render: function *(name, layout) {
        this.beforeRender();
    }
}


fs.readdirSync(__dirname).forEach(function(file) {
    var controller, type, moduleName;

    moduleName = file.substr(0, file.indexOf('.'));

    if (moduleName !== 'index' && moduleName !== 'appController') {
        controller = require('./' + moduleName);
        type       = typeof(controller);

        if (type != 'function' && type != 'array' && type == 'object') {
            return exports[moduleName] = _.assign({}, appController, controller);
        } else {
            return exports[moduleName] = controller;
        }
    }
});