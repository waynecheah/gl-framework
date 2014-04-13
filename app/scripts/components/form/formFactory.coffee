'use strict'

angular.module 'glApp'

.factory 'validation', ($http) ->
    formRules  = {}
    showingErr = {}

    validateField = (rules, field, value) ->
        rs =
            err: no
            msg: null

        return null if field of rules is false # validation rule does not applies to this field

        angular.forEach rules[field], (ruleVal, rule) -> # loop all rules
            return unless rs.err is no # skip further checking if this field has already found error

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
        angular.forEach formRules, (hasValidate) ->
            return if not valid
            valid = no if hasValidate is false
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
#        $http.get '/scripts/user/userModel.json'
#        .success (data, status, headers, config) ->
#            console.warn data
#            s = true
#            return
#        .error (data, status, headers, config) ->
#            e = true
#            return

        angular.forEach @rules, (rules, field) ->
            formRules[field]  = false
            showingErr[field] = no
            return

        @scope.onAlert = no
        @scope.err     = {}
        @scope.invalid = yes
        return
    # END init
    
    validate: (fd) ->
        return unless @scope[@form][fd].$dirty

        se = @scope
        fm = @form
        er = no

        if angular.isUndefined se.user[fd]
            value = document.querySelector("form[name=#{fm}] input[name=#{fd}]").value
        else
            value = se.user[fd]

        fail = validateField @rules, fd, value
        if fail
            se.invalid = er = fail.err
            se.err[fd] = fail.msg

        se[fm][fd].$invalid = er
        se[fm][fd].$valid   = !er

        if se[fm][fd].$invalid
            showingErr[fd]  = yes
            formRules[fd]   = false if fd of formRules is true
            se["#{fd}Cls"]  = 'has-error bg-danger'
            se["#{fd}Icon"] = 'icon-times'
        else if se[fm][fd].$valid
            showingErr[fd]  = no
            formRules[fd]   = true if fd of formRules is true
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
        er = no

        if angular.isUndefined se.user[fd]
            value = document.querySelector("form[name=#{fm}] input[name=#{fd}]").value
        else
            value = se.user[fd]

        fail = validateField @rules, fd, value

        se.invalid = er = fail.err if fail

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