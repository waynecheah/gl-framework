'use strict'

glApp

    .controller 'AppCtrl', ($scope, $http, gettext) ->
        ucword = (name) ->
            words = name.split ' '
            angular.forEach words, (word, i) ->
                words[i] = word[0].toUpperCase()+word.slice 1
                return
            words.join ' '
        # END ucword

        randomProfile = (callback) ->
            $http.get 'http://api.randomuser.me/?gender=female'
            .success (data, status, headers, config) ->
                user     = data.results[0].user
                photo    = user.picture
                fullname = ucword user.name.first+' '+user.name.last
                callback photo, fullname
                return
            .error (data, status, headers, config) ->
                console.warn data
                return
            return
        # END randomProfile

        $scope.fullname  = gettext 'Wayne Cheah'
        $scope.fullname1 = gettext 'Wayne Cheah'
        $scope.fullname2 = gettext 'Kok Weng'

        randomProfile (photo, fullname) ->
            $scope.photo    = photo
            $scope.fullname = fullname
            return

        setTimeout ->
            randomProfile (photo, fullname) ->
                $scope.photo1    = photo
                $scope.fullname1 = fullname
                return
            return
        , 800
        setTimeout ->
            randomProfile (photo, fullname) ->
                $scope.photo2    = photo
                $scope.fullname2 = fullname
                return
            return
        , 1600

        return
    .controller 'MainCtrl', ['$scope', 'gettext', ($scope, gettext) ->
        $scope.crossbind = gettext 'Default ng data'
        $scope.pageTitle = gettext 'Angular + Polymer'
        $scope.awesomeThings = [
            'HTML5 Boilerplate'
            'AngularJS'
            'Karma'
        ]
        return
    ]
    .controller 'navigationCtrl', ['$scope', '$location', ($scope, $location) ->
        $scope.isActive = (path) ->
            rs = path is $location.path()
            #debugger path+' is '+rs
            rs
        # END isActive
        return
    ]

.animation '.toggle', ->
    leave: (element, done) ->
        element.css 'overflow', 'hidden'
        TweenLite.to element, 0.3,
            opacity: 0
            height: 0
            ease: Cubic.easeIn
            onComplete: done
        return
    enter: (element, done) ->
        element.css 'overflow', 'auto'
        element.css 'height', 'auto'
        TweenLite.from element, 0.3,
            opacity: 0
            height: 0
            ease: Bounce.easeOut
            delay: 0.1
            onComplete: done
        return
