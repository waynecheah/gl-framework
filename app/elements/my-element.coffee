
Polymer 'my-element',
    crossBind: 'Default Data'
    onwer: 'Wayne Cheah'
    loaded: no

    ready: ->
        console.log 'Polymer is ready~!'
        @async (obj) ->
            console.log 'After 2 seconds wait time'
            @$.myEl.textContent = obj.label + @owner
            @loaded             = yes
            return
        , label: 'Author: ', 2000
        return
    # END ready

    crossBindChanged: -> # quick fix to bind Polymer data back to Angular
        elem   = document.querySelector 'input[ng-model="crossBind"]'
        scope  = angular.element(elem).scope()
        #scope  = angular.element('[ng-model="crossBind"]:first').scope()
        newVal = @crossBind
        scope.$apply ->
            scope.crossBind = newVal
            return
        return
    # END crossBindChanged

    ownerChanged: ->
        return unless @loaded
        return @$.myEl.textContent = 'Author: -' unless @owner
    
        @owner = @owner[0].toUpperCase() + @owner.slice 1
        @$.myEl.textContent = "Author: #{@owner}"
        return
    # END ownerChanged

    resetName: ->
        @owner = 'Wayne Cheah'
        return
    # END resetName
