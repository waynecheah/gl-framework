'use strict'

glApp.users =

    angular.module 'glApp.users', [
        # module dependency
        #'glApp.users.factory'
    ]

    .config ['$routeProvider', ($routeProvider) ->
        $routeProvider
        .when '/users/login',
            templateUrl: 'scripts/user/signin.html'
            controller: 'SigninCtrl'
        .when '/users/register',
            templateUrl: 'scripts/users/register.html'
            controller: 'RegisterCtrl'
        return
    ]

    .controller 'LoginController', ['$scope', '$routeParams', 'gettext', ($scope, $routeParams, gettext) ->
        console.log $routeParams
        $scope.username = gettext 'username'
        $scope.password = gettext 'password'
        return
    ]
    .controller 'SigninCtrl', ['$scope', 'validation', 'auth', '$location', ($scope, validation, auth, $location) ->
        fm = 'loginForm' # form name

        $scope.googleLogged = no
        $scope.$watch 'googleLogged', (newValue, oldValue) ->
            return unless newValue
            console.warn newValue, oldValue
            console.log gapi.user

        $scope.user  = {}
        $scope.error = {}

        validation.init $scope, fm

        $scope.validate = (fd) -> # call when trigger on blur
            validation.validate fd
        # END validate

        $scope.isValid = (fd) -> # call when detect change instantly
            validation.isValid fd
        # END isValid
    ]
    .controller 'LoginCtrl', ($scope, validation, auth, $location, gettext) ->
        fm = 'loginForm' # form name

        $scope.login = ->
            if $scope[fm].$valid
                promise = auth.login $scope.user
                promise.then success, error
            return
        # END login

        success = (res) ->
            localStorage.setItem 'auth_token', res.data.auth_token
            $location.path '/dashboard'
            return
        # END success

        error = ->
            $scope.invalidCredentials = true
            $scope.onAlert      = true
            $scope.alertMessage = gettext 'Wrong credentials'
            return
        # END error
        return

    .controller 'RegisterCtrl', ['$scope', '$routeParams', 'gettext', ($scope, $routeParams, gettext) ->
        console.log $routeParams
        $scope.fullname = gettext 'fullname'
        return
    ]
