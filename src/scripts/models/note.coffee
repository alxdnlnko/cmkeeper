NoteFabric = ($q, Backend, Errors) ->
  Note = (obj) ->
    @objectId = obj?.objectId ? null
    @name = obj?.name ? ''
    @content = obj?.content ? ''
    @archived = obj?.archived ? false
    @created = if obj?.created then new Date(obj.created) else null
    @categoryId = obj?.categoryId ? null

    @isEditing = false
    @nameBackup = null
    @contentBackup = null
    @

  Note::startEditing = ->
    return false if @isEditing
    @nameBackup = @name
    @contentBackup = @content
    @isEditing = true

  Note::cancelEditing = ->
    return false if not @isEditing
    @name = @nameBackup
    @content = @contentBackup
    @nameBackup = null
    @contentBackup = null
    @isEditing = false

  Note::save = ->
    deferred = $q.defer()
    if @isEditing
      @nameBackup = null
      @contentBackup = null
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
