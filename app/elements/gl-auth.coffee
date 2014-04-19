
Polymer 'gl-auth',
    apiKey: 'AIzaSyD6z5RkfXSuBKGwm0djIHoRWm-OLsS7IYI'
    clientId: '341678844265-5ak3e1c5eiaglb2h9ortqbs9q57ro6gb.apps.googleusercontent.com'
    scopes: 'https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/userinfo.email'
    onwer: 'Wayne Cheah'
    loaded: no

    ready: ->
        console.info 'Google Authentication is ready~!'

        @loaded  = yes
        apiKey   = @apiKey
        glParams =
            client_id: @clientId
            scope: @scopes
            immediate: true
        element  = @$.btnGl
        ngModel  = @ng

        onComplete = (status) ->
            elem  = document.querySelector 'input[ng-model="'+ngModel+'"]'
            scope = angular.element(elem).scope()
            scope.$apply ->
                scope.googleLogged = status
                return
        # END onComplete

        gapi =
            status: null,

            onload: ->
                console.log 'Client library is loaded'
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
                return gapi.makeApiCall() if authResult and not authResult.error
                console.log 'User has not sign-in with Google+'
                gapi.status     = no
                element.onclick = gapi.handleAuthClick
                return

            getGooglePlusLib: ->
                console.log 'Get Goolge+ API library'
                gapi.client.load 'plus', 'v1', @makeApiCall
                return

            makeApiCall: ->
                return gapi.getGooglePlusLib() if 'plus' of gapi.client is false
                token = gapi.auth.getToken()

                console.log 'Make Google+ API request'
                request = gapi.client.plus.people.get
                    userId: 'me'
                    fields: 'id,displayName,emails,image,name,nickname'
                request.execute (res) ->
                    return if typeof(localStorage) is 'undefined'
                    user =
                        username: res.emails[0].value
                        fullname: res.displayName
                        services:
                            google: token
                    try
                        localStorage.setItem('user', JSON.stringify user)
                        onComplete yes
                    catch e
                        console.log 'Quota exceeded!' if e is QUOTA_EXCEEDED_ERR
                    return
                return

            handleAuthClick: ->
                onComplete 'geng' # TODO: remove later as this only for test

                glParams.immediate = false
                gapi.status        = 'progress'
                gapi.auth.authorize glParams, (authResult) ->
                    token       = gapi.auth.getToken()
                    gapi.status = if token then 'callback' else 'cancelled'
                    gapi.handleAuthResult authResult
                    return
                off
        # END gapi

        window.gapi       = gapi
        window.gapiOnload = gapi.onload

        po       = document.createElement 'script'
        po.type  = 'text/javascript'
        po.async = yes
        po.src   = '//apis.google.com/js/client.js?onload=gapiOnload';
        scriptEl = document.getElementsByTagName('script')[0]
        scriptEl.parentNode.insertBefore po, scriptEl
        return
    # END ready

    ownerChanged: ->
        return unless @loaded
        #@$.myEl.textContent = "Author: #{@owner}"
        return
    # END ownerChanged
