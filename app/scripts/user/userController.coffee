'use strict'

glApp.users =

    angular.module 'glApp.users', [
        # module dependency
        #'glApp.users.factory'
    ]

    .config ['$routeProvider', ($routeProvider) ->
        $routeProvider
        .when '/users/login',
            templateUrl: 'scripts/user/login.html'
            controller: 'LoginCtrl'
        .when '/users/register',
            templateUrl: 'scripts/users/register.html'
            controller: 'RegisterCtrl'
        .otherwise
            redirectTo: '/'
        return
    ]

    .controller 'LoginController', ['$scope', '$routeParams', ($scope, $routeParams) ->
        console.log $routeParams
        $scope.username = 'username'
        $scope.password = 'password'
        return
    ]
    .controller 'LoginCtrl', ['$scope', 'validation', 'auth', '$location', ($scope, validation, auth, $location) ->
        fm = 'loginForm' # form name

        $scope.rules = {
            email: {
                required: true
                email: true
                minlength: 6
                maxlength: 50
            },
            password: {
                required: true,
                pattern: '/^.{6,50}$/'
            }
        }
        $scope.error = {}

        validation.init $scope, fm

        $scope.validate = (fd) -> # call when trigger on blur
            validation.validate fd
        # END validate

        $scope.isValid = (fd) -> # call when detect change instantly
            validation.isValid fd
        # END isValid

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
            return
        # END error
        return
    ]
    .controller 'RegisterCtrl', ['$scope', '$routeParams', ($scope, $routeParams) ->
        console.log $routeParams
        $scope.fullname = 'fullname'
        return
    ]
