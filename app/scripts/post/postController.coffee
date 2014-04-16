'use strict'

glApp.posts =

    angular.module 'glApp.posts', [
    ]

    .config ['$routeProvider', ($routeProvider) ->
        $routeProvider
        .when '/posts',
            templateUrl: 'scripts/post/post.html'
            controller: 'PostCtrl'
        return
    ]

    .provider 'Post', ->
        @$get = ['$resource', ($resource) ->
            $resource 'http://localhost:3000/post/:_id', {},
                update:
                    method: 'PUT'
        ]
        return

    .controller 'PostCtrl', ['$scope', '$route', 'Post', ($scope, $route, Post) ->
        $scope.post  = new Post()
        $scope.posts = Post.query() # method GET | isArray

        $scope.newPost    = ->
            $scope.post    = new Post()
            $scope.editing = false
            return
        # END newPost

        $scope.activePost = (post) ->
            $scope.post    = post
            $scope.editing = true
            return
        # END activePost

        $scope.save = (post) ->
            if $scope.post._id
                Post.update # method PUT
                    _id: $scope.post._id
                , $scope.post
            else
                $scope.post.$save().then (res) -> # method POST
                    $scope.posts.push res
                    return

            $scope.editing = false
            $scope.post    = new Post()
            return
        # END save

        $scope.delete = (post) ->
            Post.delete(post) # method DELETE
            #_.remove($scope.posts, post)
            return
        # END delete

        return
    ]