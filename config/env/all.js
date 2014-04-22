
var path = require('path');
var root = path.normalize(__dirname + '/../..');

module.exports = {
    root: root,
    port: process.env.PORT || 3000,
    db: process.env.MONGOHQ_URL,
    dbHost: 'mongodb://cheah.homeip.net/mydb',
    dbHosts: ['mongodb://server1.com:27101', 'mongodb://server2.com:27102', 'mongodb://server3.com:27103'],
    replication: false
};
