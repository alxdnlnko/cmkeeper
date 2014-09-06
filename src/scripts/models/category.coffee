CategoryFabric = ($q, Backend) ->
  Category = (obj) ->
    @objectId = obj?.objectId ? null
    @name = obj?.name ? ''
    @created = if obj?.created then new Date(obj.created) else null

    @isSaving = false
    @

  Category::save = ->
    deferred = $q.defer()

    if @objectId
      method = 'PUT'
      url = "data/Categories/#{@objectId}"
    else
      method = 'POST'
      url = "data/Categories"

    @isSaving = true
    Backend.makeRequest url, name: @name, method
      .success (data, status) =>
        @isSaving = false
        @[key] = val for key, val of data when key of @
        deferred.resolve @
      .error (data, status) =>
        @isSaving = false
        deferred.reject data
    return deferred.promise

  Category.objects =
    all: () ->
      deferred = $q.defer()
      Backend.makeRequest 'data/Categories', sortBy: 'created', 'GET'
        .success (data, status) ->
          deferred.resolve data.data.map (item) -> new Category item
        .error (data, status) ->
          deferred.reject data
      return deferred.promise
    get: (categoryId) ->

  return Category


angular.module 'CMKeeper'
  .factory 'Category', [
    '$q',
    'Backend',
    CategoryFabric]
