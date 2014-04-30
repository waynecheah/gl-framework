'use strict'

angular.module 'glApp'

.service 'PostService', () ->
    id    = null
    posts = []

    @save = (post) 
        if post.id is null  # if this is new post, add it in posts array
            posts.push post
        else # for existing post, find this post using id and update it.
            posts[_i] = post for ps in posts when ps.id is post.id
        return
    # END save

    @get = (id) ->
        return post for post in posts when post.id is id
    # END get

    @delete = (id) ->
        posts.splice _i, 1 for post in posts when post.id is id
        return
    # END delete

    @list = ->
        posts;
    # END list

    return
# END service   