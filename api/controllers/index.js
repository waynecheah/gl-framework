var fs = require('fs');

//var appController = require('./appController');
var appController = function *() {
    return {
        layout: 'default',

        beforeRender: function *() {},

        render: function *(name, layout) {
            this.beforeRender();
        }
    }
} // appController


//fs.readdirSync(__dirname).forEach(function(file) {
//    var controller, moduleName;
//
//    moduleName = file.substr(0, file.indexOf('.'));
//
//    if (moduleName !== 'index' && moduleName !== 'appController') {
//        controller = require('./' + moduleName);
//
//        if (!_.isFunction(controller) && !_.isArray(controller) && _.isObject(controller)) {
//            return exports[moduleName] = _.assign(appController(), controller);
//        } else {
//            return exports[moduleName] = controller;
//        }
//    }
//});