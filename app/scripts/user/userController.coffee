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
    .controller 'LoginCtrl', ['$scope', 'auth', '$location', ($scope, auth, $location) ->
        fm = 'loginForm' # form name

        $scope.validate = (fd) -> # call when trigger on blur
            if $scope[fm][fd].$dirty
                # more validation checking goes here
                # $scope[fm][fd].error = validate $scope, fm, fd

                if $scope[fm][fd].$invalid
                    $scope[fm][fd].error = yes
                else if $scope[fm][fd].$valid
                    $scope[fm][fd].error = no
            return
        # END validate

        $scope.isValid = (fd) -> # call when detect change instantly
            $scope[fm][fd].error = no if $scope[fm][fd].$valid
            return
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
