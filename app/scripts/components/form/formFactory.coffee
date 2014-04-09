'use strict'

angular.module 'glApp'

.factory 'validation', ->
    scope: null,
    form: null,

    init: (scope, form) ->
        @scope = scope
        @form  = form
        return
    # END init

    validate: (fd) ->
        se = @scope
        fm = @form
        el = document.querySelector "form[name=#{fm}] input[name=#{fd}]"

        min = angular.element(el).attr 'ng-minlength'

        if el.value.length < min
            se.error[fd] = "Too short, minimum #{min} characters"

        if se[fm][fd].$dirty
            if se[fm][fd].$invalid
                se[fm][fd].error = yes
            else if se[fm][fd].$valid
                se[fm][fd].error = no

        return
    # END validate

    isValid: (fd) ->
        se = @scope
        fm = @form

        se[fm][fd].error = no if se[fm][fd].$valid
        return
    # END isValid
# END factory