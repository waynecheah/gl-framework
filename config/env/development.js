
module.exports = {
    db: 'mongodb://localhsot/mydb',
    dbHost: 'mongodb://cheah.homeip.net/mydb',
    replication: false,
    webPort: 9000,
    facebook: {
        appId: '553789621375577',
        status: true,
        cookie: false,
        email: true,
        callbackURL: 'http://localhost:8080/#/auth/facebook/callback'
    },
    google: {
        apiKey: 'AIzaSyD6z5RkfXSuBKGwm0djIHoRWm-OLsS7IYI',
        clientID: '341678844265-5ak3e1c5eiaglb2h9ortqbs9q57ro6gb.apps.googleusercontent.com',
        //clientSecret: 'abc',
        scopes: 'https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/userinfo.email',
        callbackURL: 'http://localhost:8080/#/auth/google/callback'
    }
};
