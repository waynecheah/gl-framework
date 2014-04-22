
module.exports = {
    db: 'mongodb://localhsot/mydb',
    app: '',
    facebook: {
        clientID: '123',
        clientSecret: 'abc',
        callbackURL: 'http://localhost:8080/auth/facebook/callback'
    },
    google: {
        clientID: '123',
        clientSecret: 'abc',
        callbackURL: 'http://localhost:8080/auth/google/callback'
    }
};
