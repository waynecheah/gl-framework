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
  # END directive 