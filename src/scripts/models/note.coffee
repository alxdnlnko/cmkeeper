NoteFabric = ($q, Backend, Errors) ->
  Note = (obj) ->
    @objectId = obj?.objectId ? null
    @name = obj?.name ? ''
    @content = obj?.content ? ''
    @archived = obj?.archived ? false
    @created = if obj?.created then new Date(obj.created) else null
    @categoryId = obj?.categoryId ? null

    @isEditing = false
    @editedName = null
    @editedContent = null
    @

  Note::startEditing = ->
    return false if @isEditing
    @editedName = @name
    @editedContent = @content
    @isEditing = true

  Note::cancelEditing = ->
    return false if not @isEditing
    @editedName = null
    @editedContent = null
    @isEditing = false

  Note::save = ->
    deferred = $q.defer()
    if @isEditing
      @name = @editedName
      @content = @editedContent
      @editedName = null
      @editedContent = null
      @isEditing = false

    if @objectId
      url = "data/Notes/#{@objectId}"
      method = 'PUT'
    else
      url = 'data/Notes'
      method = 'POST'

    Backend.makeRequest(url,
        name: @name, content: @content, categoryId: @categoryId, archived: @archived
        method
    ).success (data, status) =>
      @[key] = val for key, val of data when key of @
      deferred.resolve @
    .error (data, status) =>
      deferred.reject data
    return deferred.promise

  Note::del = () ->
    deferred = $q.defer()
    if @objectId
      Backend.makeRequest "data/Notes/#{@objectId}", {}, 'DELETE'
        .success (data, status) ->
          deferred.resolve data
        .error (data, status) ->
          deferred.reject data
    else
      deferred.reject()
    return deferred.promise

  Note.objects =
    all: (categoryId) ->
      deferred = $q.defer()
      Backend.makeRequest('data/Notes',
        where: "categoryId='#{categoryId}'",
        'GET'
      ).success (data, status) ->
        deferred.resolve data.data.map (item) -> new Note item
      .error (data, status) ->
        deferred.reject data
      return deferred.promise
    get: (noteId) ->

  return Note


angular.module 'CMKeeper'
  .factory 'Note', [
    '$q',
    'Backend',
    'Errors',
    NoteFabric]
