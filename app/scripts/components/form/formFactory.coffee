'use strict'

angular.module 'glApp'

.factory 'validation', ($http) ->
    formRules  = {}
    showingErr = {}

    validateField = (scope, rules, field, value) ->
        rs =
            err: no
            msg: null

        return if field of rules is false # validation rule does not applies to this field

        angular.forEach rules[field], (ruleVal, rule) -> # loop all rules
            return unless er is no # skip further checking if this field has already found error

            switch rule
                when 'required'
                    return unless ruleVal # empty value means optional field
                    if value.length is 0
                        rs.err = yes
                        rs.msg = 'This field is required'
                when 'minlength'
                    if value.length < ruleVal
                        rs.err = yes
                        rs.msg = "Too short. Minimum #{ruleVal} characters"
                when 'maxlength'
                    if value.length > ruleVal
                        rs.err = yes
                        rs.msg = "Too long. Maximum #{ruleVal} characters"
                when 'email'
                    return unless ruleVal # empty values means do not apply email validation check
                    re = new RegExp /^[a-zA-Z0-9_\.\-]+\@([a-zA-Z0-9\-]+\.)+[a-zA-Z0-9]{2,4}$/
                    unless re.test value
                        rs.err = yes
                        rs.msg = 'Invalid email address'
                when 'regexp'
                    return unless ruleVal and 'pattern' of ruleVal is true # custom check via RegExp
                    re = new RegExp ruleVal.pattern
                    unless re.test value
                        rs.err = yes
                        rs.msg = if 'onError' of ruleVal is true then ruleVal.onError else 'This field is invalid'
            return

        if rs.err then rs else null
    # END validateField

    validateForm = ->
        valid = yes
        angular.forEach formRules, (hasValid) ->
            return if not valid
            valid = no if hasValid is false
            return
        valid
    # END validateForm

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
                regexp: {
                    pattern: '^.{6,50}$'
                    onError: 'Between 6 to 50 characters'
                }
            }
        }
#        $http.get '/users/model/rules.json'
#        .success (data, status, headers, config) ->
#            s = true
#            return
#        .error (data, status, headers, config) ->
#            e = true
#            return
#
#        angular.forEach @rules, (rules, field) ->
#            formRules[field]  = false
#            showingErr[field] = no
#            return

        @scope.onAlert = no
        @scope.err     = {}
        @scope.invalid = yes
        return
    # END init
    
    validate: (fd) ->
        return unless @scope[@form][fd].$dirty

        se = @scope
        fm = @form
        el = document.querySelector "form[name=#{fm}] input[name=#{fd}]"
        vl = el.value # se.user[fd]
        er = no

        if fd of @rules is true # rule applies to this field
            angular.forEach @rules[fd], (val, rule) ->
                return unless er is no # skip further checking if error on this field has found
                se.err[fd] = ''
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
                    when 'regexp'
                        return unless val and 'pattern' of val is true
                        re = new RegExp val.pattern
                        unless re.test vl
                            er         = yes
                            se.err[fd] = val.onError
                #console.log rule+' = '+val
                return

        se[fm][fd].$invalid = er
        se[fm][fd].$valid   = !er

        if se[fm][fd].$dirty
            if se[fm][fd].$invalid
                showingErr[fd]  = yes
                se["#{fd}Cls"]  = 'has-error bg-danger'
                se["#{fd}Icon"] = 'icon-times'
            else if se[fm][fd].$valid
                showingErr[fd]  = no
                se["#{fd}Cls"]  = 'has-success'
                se["#{fd}Icon"] = 'icon-check'

        se[fm].$valid = validateForm()
        if se[fm].$valid # form is validated!
            se[fm].$invalid = false
            se.invalid      = false
        else
            se[fm].$invalid = true
            se.invalid      = true

        return
    # END validate

    isValid: (fd) ->
        se = @scope
        fm = @form
        el = document.querySelector "form[name=#{fm}] input[name=#{fd}]"
        vl = el.value
        er = no

        if fd of @rules is true # rule applies to this field
            angular.forEach @rules[fd], (val, rule) -> # loop all rules
                return unless er is no # skip further checking if error on this field has found
                switch rule
                    when 'required'
                        return unless val # empty value means optional field
                        er = yes if vl.length is 0
                    when 'minlength'
                        er = yes if vl.length < val
                    when 'maxlength'
                        er = yes if vl.length > val
                    when 'email'
                        return unless val # empty values means do not apply email validation check
                        re = new RegExp /^[a-zA-Z0-9_\.\-]+\@([a-zA-Z0-9\-]+\.)+[a-zA-Z0-9]{2,4}$/
                        er = yes unless re.test vl
                    when 'regexp'
                        return unless val and 'pattern' of val is true # custom check via RegExp
                        re = new RegExp val.pattern
                        er = yes unless re.test vl
                return

        se[fm][fd].$invalid = er
        se[fm][fd].$valid   = !er

        if se[fm][fd].$invalid # when error found in this field
            fieldErrorClass = if showingErr[fd] then 'has-error bg-danger' else 'has-error'
            formRules[fd]   = false if fd of formRules is true
            se["#{fd}Cls"]  = fieldErrorClass
            se["#{fd}Icon"] = 'icon-times'
        else if se[fm][fd].$valid
            formRules[fd]   = true if fd of formRules is true
            showingErr[fd]  = no
            se["#{fd}Cls"]  = 'has-success'
            se["#{fd}Icon"] = 'icon-check'
            se.err[fd]      = '' # hide error message below the field when validated

        se[fm].$valid = validateForm()
        if se[fm].$valid # form is validated!
            se[fm].$invalid = false
            se.invalid      = false
        else
            se[fm].$invalid = true
            se.invalid      = true

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