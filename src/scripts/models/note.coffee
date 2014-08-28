NoteFabric = ($http) ->
  Note = (obj) ->
    @id = obj?.id ? null
    @name = obj?.name ? ''
    @content = obj?.content ? ''
    @archived = obj?.archived ? false
    @

  Note::$save = ->

  Note.$objects =
    $all: (categoryId, cb) ->
      $http.get "/api/category/#{@categoryId}/note"
        .success (data, status) ->
          cb?(null, new Note obj for obj in data)
    $get: (noteId) ->

  return Note


angular.module 'CMKeeper'
  .factory 'Note', ['$http', NoteFabric]
