'use strict'

angular.module 'glApp'
  .service 'auth', ($http) ->
    this.login = (user) ->
      $http.post '/users/login', email: user.email, password: user.password
    return
  # END service 