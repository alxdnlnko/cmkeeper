CategoryFabric = ($http) ->
  Category = (obj) ->
    @id = obj?.id ? null
    @name = obj?.name ? ''
    @

  Category::$save = ->

  Category.$objects =
    $all: (cb) ->
      $http.get '/api/category'
        .success (data, status) ->
          cb?(null, new Category obj for obj in data)
    $get: (categoryId) ->

  return Category


angular.module 'cmIndex'
  .factory 'Category', ['$http', CategoryFabric]
