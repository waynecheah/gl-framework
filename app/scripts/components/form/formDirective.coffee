'use strict'

angular.module 'glApp'

.directive 'glFocus', ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attrs, controller) ->
        controller.$focused = no

        element[0].addEventListener 'focus', ->
        #element.bind 'focus', ->
            scope.$apply ->
                controller.$focused = yes
                return
            return

        element[0].addEventListener 'blur', ->
        #element.bind 'blur', ->
            scope.$apply ->
                controller.$focused = no
                return
            return

        return
    # END link
# END glFocus

.directive 'glForm', ($compile) ->
    restrict: 'E'
    replace: true
    templateUrl: 'scripts/user/signin.html'
    controller: ($scope) ->
        $scope.login = ->
            console.log 'submited'
        return
    compile: (element, attrs) ->
        attrs.$set 'ng-submit', 'login()'
        content = angular.element '<div ng-click="login()">Test</div>'
        content.append(element.contents())
        element.replaceWith content
        return
#    link: (scope, elem, attrs) ->
#        attrs.$set 'ng-click', 'login()'
#        angular.forEach elem.find('input'), (el) ->
#            console.log el
#            return
#        return
# END glForm