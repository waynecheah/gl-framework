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
