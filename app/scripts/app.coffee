'use strict'

glApp =

    angular.module 'glApp', [
        'ngAnimate'
        'ngResource'
        'ngSanitize'
        'ngRoute'
        'placeholders'
        'ui.bootstrap'
        'glApp.posts'
        'glApp.users'
    ]

    .factory 'authInterceptor', ->
        request: (config) ->
            config.headers       = config.headers || {}
            config.headers.token = localStorage.auth_token if localStorage.oauth_token
            config

    .config ['$httpProvider', ($httpProvider) ->
        delete $httpProvider.defaults.headers.common['X-Requested-With']
        $httpProvider.interceptors.push 'authInterceptor'
        return
    ]
    .config ['$routeProvider', ($routeProvider) ->
        $routeProvider
        .when '/',
            templateUrl: 'scripts/main.html'
            controller: 'MainCtrl'
        .when '/about',
            templateUrl: 'scripts/about.html'
            controller: 'MainCtrl'
        .otherwise
            redirectTo: '/'
        return
    ]

    .constant 'facebookAPI',
        appId: '553789621375577'
        status: true
        cookie: off
        email: on
    .constant 'googleAPI',
        apiKey: 'AIzaSyD6z5RkfXSuBKGwm0djIHoRWm-OLsS7IYI'
        client_id: '341678844265-5ak3e1c5eiaglb2h9ortqbs9q57ro6gb.apps.googleusercontent.com'
        scope: 'https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/userinfo.email'
        immediate: yes
