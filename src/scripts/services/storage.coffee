Storage = (Note, Category, Errors, $rootScope, $q) ->
  @categories = []
  @currentCategory = null

  @notes = []
  @currentNote = null

  @newCategory = null

  @isLoadingNotes = false

  @loadCategories = () ->
    deferred = $q.defer()
    Category.objects.all()
      .then(
        (data) =>
          @categories = data
          deferred.resolve data
        (err) ->
          deferred.reject err
      )
    return deferred.promise

  @selectCategory = (id) ->
    @currentNote = null

    if id is null
      @currentCategory = null
      return null

    category = (cat for cat in @categories when cat.objectId is id)[0]
    return false if not category

    @currentCategory = category
    return category

  @loadNotes = (categoryId) ->
    deferred = $q.defer()
    @isLoadingNotes = true
    @notes = []
    Note.objects.all categoryId
      .then(
        (data) =>
          @isLoadingNotes = false
          @notes = data
          deferred.resolve data
        (err) ->
          @isLoadingNotes = false
          deferred.reject err
      )
    return deferred.promise

  @selectNote = (id) ->
    if id is null
      @currentNote = null
      return null

    return true if @currentNote?.objectId is id
    note = (note for note in @notes when note.objectId is id)[0]
    return false if not note
    @currentNote = note
    return note

  @addCategory = () ->
    @newCategory = new Category()

  @saveNewCategory = () ->
    if not @newCategory.name
      @newCategory = null
      return
    category = @newCategory
    category.created = new Date()
    @categories.push category
    category.save()
    @newCategory = null

  @startEditing = () ->
    return if not @currentNote
    @currentNote.startEditing()

  @addNote = () ->
    return if not @currentCategory
    @currentNote = new Note()
    @currentNote.startEditing()

  @saveEditing = () ->
    return if not @currentNote or not @currentNote.isEditing
    return if not @currentNote.name
    if not @currentNote.objectId
      @notes.unshift @currentNote
      @currentNote.categoryId = @currentCategory.objectId
    do (note = @currentNote) ->
      note.save()
        .then () ->
          $rootScope.$broadcast 'newNoteSaved', note

    # if not @currentNote  # adding a new note
    #   @currentNote = new Category(@editedNote)
    #   @notes.unshift @currentNote
    #   do (note = @currentNote) ->
    #     note.$save().then (data) ->
    #       console.log "#{note.id} added!"
    #       $rootScope.$broadcast 'newNoteSaved', note
    #     , (data) ->
    #       console.log "Can't save #{note.id} note"
    # else
    #   @currentNote[key] = val for key, val of @editedNote
    #   do (note = @currentNote) ->
    #     note.$update().then (data) ->
    #       console.log "#{note.id} saved!"
    #     , (data) ->
    #       console.log "Can't save #{note.id} note"
    # @editedNote = null

  @cancelEditing = () ->
    return if not @currentNote
    @currentNote.cancelEditing()
    @currentNote = null
  @

angular.module 'CMKeeper'
  .service 'Storage', [
    'Note',
    'Category',
    'Errors',
    '$rootScope',
    '$q',
    Storage]
