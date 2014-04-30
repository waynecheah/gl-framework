'use strict'

window.env    = 'dev'
window.gdebug = (name, collapsed=false) ->
    return if 'env' of window is false

    if not name
        console.groupEnd()
    else
        if collapsed then console.groupCollapsed name else console.group name
    return
# END gdebug

window.debug = (msg, type='log') ->
    return if 'env' of window is false
    switch type
        when 'log' then console.log msg
        when 'info' then console.info msg
        when 'err' then console.error msg
        when 'warn' then console.warn msg
        when 'table' then console.table msg
    return
# END debug


glApp =

    angular.module 'glApp', [
        'ngAnimate'
        'ngResource'
        'ngSanitize'
        'ngRoute'
        'gettext'
        'placeholders'
        'ui.bootstrap'
        'glApp.posts'
        'glApp.users'
    ]

    .run (gettextCatalog) ->
        gettextCatalog.currentLanguage = 'zh'
        gettextCatalog.debug           = true
        return

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

    .value 'debug', (msg, type='log') ->
        return if 'env' of window is false or window.env is 'pro'
        switch type
            when 'log' then console.log msg
            when 'info' then console.info msg
            when 'err' then console.error msg
            when 'warn' then console.warn msg
            when 'table' then console.table msg
        return
