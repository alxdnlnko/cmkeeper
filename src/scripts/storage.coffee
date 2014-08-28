Storage = (Note, Category, $rootScope) ->
  # Category = $resource '/api/category'
  # Note = $resource '/api/category/:categoryId/note', null,
    # update: {method: 'PUT'}

  @categories = []
  @currentCategory = null

  @notes = []
  @currentNote = null

  @editedNote = null
  @newCategory = null

  @loadCategories = () ->
    deferred = $q.defer()
    console.log 'What?'
    $timeout () ->
      console.log 'resolved!'
      deferred.resolve ['Category1', 'Category2']
    , 2000

    return deferred.promise

    # Category.$objects.$all (err, data) =>
    #   return if err
    #   @categories = data
    #   cb?()

  @loadNotes = (cb) ->
    return cb?(new Error 'No category') if not @currentCategory
    @currentCategory
    Note.$objects.$all @currentCategory.id, (err, data) =>
      return cb?() if err
      @notes = data
      cb?()

  @selectCategory = (id, cb) ->
    return cb?() if @currentCategory?.id is id
    category = (cat for cat in @categories when cat.id is id)[0]
    return cb?(new Error 'No category') if not category
    @currentCategory = category
    @currentNote = null
    @loadNotes cb

  @selectNote = (id, cb) ->
    note = (note for note in @notes when note.id is id)[0]
    return cb?(new Error 'No note') if not note
    @currentNote = note
    cb?()

  @addCategory = () ->
    @newCategory = new Category()

  @saveNewCategory = () ->
    if not @newCategory.name
      @newCategory = null
      return
    category = @newCategory
    category.$save()
    @categories.push category
    @newCategory = null

  @startEditing = () ->
    return if not @currentNote
    obj = {}
    obj[key] = val for key, val of @currentNote when key[0] isnt '$'
    @editedNote = obj

  @addNote = () ->
    @currentNote = null
    @editedNote = {name: 'Untitled note', content: ''}

  @saveEditing = () ->
    return if not @editedNote
    if not @currentNote  # adding a new note
      @currentNote = new Category(@editedNote)
      @notes.unshift @currentNote
      do (note = @currentNote) ->
        note.$save().then (data) ->
          console.log "#{note.id} added!"
          $rootScope.$broadcast 'newNoteSaved', note
        , (data) ->
          console.log "Can't save #{note.id} note"
    else
      @currentNote[key] = val for key, val of @editedNote
      do (note = @currentNote) ->
        note.$update().then (data) ->
          console.log "#{note.id} saved!"
        , (data) ->
          console.log "Can't save #{note.id} note"
    @editedNote = null

  @cancelEditing = () ->
    return if not @editedNote
    @editedNote = null
  @

angular.module 'CMKeeper'
  .service 'Storage', [
    'Note',
    'Category',
    '$rootScope',
    '$q',
    '$timeout',
    Storage]
