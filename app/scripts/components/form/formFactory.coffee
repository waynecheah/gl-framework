'use strict'

angular.module 'glApp'

.factory 'validation', ($http) ->
    scope: null,
    form: null,
    rules: {}

    init: (scope, form) ->
        @scope = scope
        @form  = form
        @rules = {
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

        @scope.onAlert = no
        @scope.err     = {}
        @scope.invalid = yes
        return
    # END init

    validate: (fd) ->
        se = @scope
        fm = @form
        el = document.querySelector "form[name=#{fm}] input[name=#{fd}]"
        vl = el.value
        er = no

        angular.forEach @rules, (rules, field) ->
            return unless field is fd and er is no and se[fm][fd].$dirty
            angular.forEach rules, (val, rule) ->
                return unless er is no
                se["#{fd}Cls"]  = ''
                se["#{fd}Icon"] = ''
                se.err[fd]      = ''
                switch rule
                    when 'required'
                        return unless val
                        if vl.length is 0
                            se.invalid = er = yes
                            se.err[fd] = "This field is required"
                    when 'minlength'
                        if vl.length < val
                            se.invalid = er = yes
                            se.err[fd] = "Too short. Minimum #{val} characters"
                    when 'maxlength'
                        if vl.length > val
                            se.invalid = er = yes
                            se.err[fd] = "Too long. Maximum #{val} characters"
                    when 'email'
                        return unless val
                        re = new RegExp /^[a-zA-Z0-9_\.\-]+\@([a-zA-Z0-9\-]+\.)+[a-zA-Z0-9]{2,4}$/
                        unless re.test vl
                            se.invalid = er = yes
                            se.err[fd] = 'Invalid email address'
                if er
                    se["#{fd}Cls"]  = 'has-error bg-danger'
                    se["#{fd}Icon"] = 'icon-times'
                console.log rule+' = '+val
            return

        se[fm][fd].$invalid = er if er
        se.invalid = if se[fm].$valid then no else yes

        if se[fm][fd].$dirty
            if se[fm][fd].$invalid
                se["#{fd}Cls"]  = 'has-error'
                se["#{fd}Icon"] = 'icon-times'
            else if se[fm][fd].$valid
                se["#{fd}Cls"]  = 'has-success'
                se["#{fd}Icon"] = 'icon-check'

        return
    # END validate

    isValid: (fd) ->
        se = @scope
        fm = @form
        el = document.querySelector "form[name=#{fm}] input[name=#{fd}]"
        vl = el.value
        er = no

        angular.forEach @rules, (rules, field) ->
            return unless field is fd and er is no and se[fm][fd].$dirty
            angular.forEach rules, (val, rule) ->
                return unless er is no
                switch rule
                    when 'required'
                        return unless val
                        er = yes if vl.length is 0
                    when 'minlength'
                        er = yes if vl.length < val
                    when 'maxlength'
                        er = yes if vl.length > val
                    when 'email'
                        return unless val
                        re = new RegExp /^[a-zA-Z0-9_\.\-]+\@([a-zA-Z0-9\-]+\.)+[a-zA-Z0-9]{2,4}$/
                        er = yes unless re.test vl
                return
            return

        se[fm][fd].$invalid = er if er
        se.invalid          = if se[fm].$valid then no else yes

        if se[fm][fd].$invalid
            se["#{fd}Cls"]  = 'has-error'
            se["#{fd}Icon"] = 'icon-times'
        else if se[fm][fd].$valid
            se["#{fd}Cls"]  = 'has-success'
            se["#{fd}Icon"] = 'icon-check'
            se.err[fd]      = ''

        return
    # END isValid
# END factory

.factory 'validation2', ->
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