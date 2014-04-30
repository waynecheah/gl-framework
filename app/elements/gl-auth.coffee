
Polymer 'gl-auth',
    clientId: '341678844265-5ak3e1c5eiaglb2h9ortqbs9q57ro6gb.apps.googleusercontent.com'
    scopes: 'https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/userinfo.email'
    onwer: 'Wayne Cheah'
    loaded: no

    ready: ->
        if 'gapi' of window is off
            window.gapi = {}
            #return

        if 'gdebug' of window is off
            window.gdebug = (a1, a2) ->
        if 'debug' of window is off
            window.debug = (a1, a2) ->

        console.info 'Google Authentication is ready~!'
        return console.warn 'apiKey not found' unless @apiKey
        return console.warn 'clientId not found' unless @clientId

        @loaded  = yes
        apiKey   = @apiKey
        glParams =
            client_id: @clientId
            scope: @scopes
            immediate: true
        element  = @$.btnGl
        ngModel  = @ng


        onComplete = (status) ->
            if ngModel
                elem  = document.querySelector 'input[ng-model="'+ngModel+'"]'
                scope = angular.element(elem).scope()
                scope.$apply ->
                    scope.googleLogged = status
                    return
            element.style.display = 'none'
            return
        # END onComplete


        gapi =
            status: null,
            user: {}

            onload: ->
                console.log 'Google APIs Client library is loaded'
                gapi.client.setApiKey apiKey

                handleAuthResult = gapi.handleAuthResult
                window.setTimeout -> # check authorization
                    console.log 'Getting authorize result from google..'
                    gapi.auth.authorize glParams, handleAuthResult
                    return
                , 1
                return

            handleAuthResult: (authResult) ->
                console.log 'Auth Results:'
                console.log authResult

                if authResult and not authResult.error
                    user   = localStorage.getItem 'user'
                    logged = authResult.status.google_logged_in # Todo(check): not sure if this done correctly
                    if logged and user # return result if already sign in with Google+
                        console.log 'User has already sign-in with Google+'
                        gapi.status = 'logged'
                        gapi.user   = JSON.parse user
                        onComplete yes
                    else # make API request and get user data
                        gapi.makeApiCall()
                else # user has not make authorisation to the App, show Sign-in button
                    console.log 'User has not sign-in with Google+'
                    gapi.status      = no
                    element.onclick  = gapi.handleAuthClick
                    element.disabled = no
                return

            getGooglePlusLib: ->
                console.log 'Get Goolge+ API library'
                gapi.client.load 'plus', 'v1', gapi.makeApiCall
                return

            makeApiCall: ->
                return gapi.getGooglePlusLib() if 'plus' of gapi.client is false
                token = gapi.auth.getToken() # should have auth token before make API request

                console.log 'Make Google+ API request'
                request = gapi.client.plus.people.get
                    userId: 'me'
                    fields: 'id,displayName,emails,image,name,nickname'
                gapi.status = 'request'
                request.execute (res) ->
                    console.log 'Response user data for the API request'
                    gapi.status = 'responsed'
                    gapi.user   =
                        username: res.emails[0].value
                        fullname: res.displayName
                        services:
                            google: token

                    # skip local storage if unavailable
                    return onComplete yes if typeof(localStorage) is 'undefined'

                    try
                        console.log 'Storage user data to local storage'
                        localStorage.setItem 'user', JSON.stringify(gapi.user)
                        onComplete yes
                    catch e
                        console.log 'Quota exceeded!' if e is QUOTA_EXCEEDED_ERR
                    return
                return

            handleAuthClick: ->
                console.log 'Attempt get authorisation from user'
                glParams.immediate = false
                gapi.status        = 'authorising'
                gapi.auth.authorize glParams, (authResult) ->
                    token = gapi.auth.getToken()
                    if token
                        console.log 'User has authorised the App to make API request'
                        gapi.status = 'callback'
                    else
                        console.warn 'User has cancelled the authorisation process'
                        gapi.status = 'cancelled'
                    gapi.handleAuthResult authResult
                    return
                off
        # END gapi

        window.gapi       = gapi
        window.gapiOnload = gapi.onload

        return if 'gapiInjected' of window is on
        window.gapiInjected = yes
        window.onblur = ->
            if window.gapi.status is 'authorising' or window.gapi.status is 'incompleted'
                console.log 'Waiting user to give authorise to the App'
        window.onfocus = ->
            if window.gapi.status is 'authorising' or window.gapi.status is 'incompleted'
                console.warn 'User has return back from incompleted authorisation process'
                window.gapi.status = 'incompleted'

        po       = document.createElement 'script'
        po.type  = 'text/javascript'
        po.async = yes
        po.src   = '//apis.google.com/js/client.js?onload=gapiOnload'
        scriptEl = document.getElementsByTagName('script')[0]
        scriptEl.parentNode.insertBefore po, scriptEl
        return
    # END ready

    ownerChanged: ->
        return unless @loaded
        #@$.myEl.textContent = "Author: #{@owner}"
        return
    # END ownerChanged
