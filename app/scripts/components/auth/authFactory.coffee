'use strict'

angular.module 'glApp'

.factory 'auth', ($http) ->
        user = {}

        onLogged = ->
            return
        onLogout = ->
            return


        setUser: (token) ->
            localStorage.auth_token = token
            return

        login: (user) ->
            $http.post '/users/login', email: user.email, password: user.password
            onLogged()
            return

        logout: ->
            onLogout()
            return
# END factory
