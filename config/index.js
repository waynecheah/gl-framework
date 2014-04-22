
var _   = require('lodash');
var env = 'NODE_ENV' in process.env ? process.env.NODE_ENV : 'development';

module.exports = _.assign(require('./env/all'), require('./env/' + env) || {});
