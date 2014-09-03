PageCtrl = ($scope, $state, $stateParams, $window, Storage) ->
  $scope.storage = Storage

  $scope.showNonArcihved = true
  $scope.showArcihved = true

  $scope.categoriesOrder = 'created'


  $scope.aceLoaded = (ace) ->
    console.log 'loaded:', ace
    ace.setFontSize 16
    ace.setHighlightActiveLine false
    ace.setShowPrintMargin false

  # UI handlers
  $scope.toggleNonArchived = () ->
    $scope.showNonArcihved = not $scope.showNonArcihved

  $scope.toggleArchived = () ->
    $scope.showArcihved = not $scope.showArcihved

  $scope.startEditing = () ->
    Storage.startEditing()

  $scope.saveEditing = () ->
    Storage.saveEditing()

  $scope.cancelEditing = () ->
    Storage.cancelEditing()

  $scope.addNote = () ->
    $state.go 'notes.category',
      categoryId: Storage.currentCategory.objectId
    Storage.addNote()

  $scope.addCategory = () ->
    Storage.addCategory()

  $scope.saveCategory = () ->
    Storage.saveNewCategory()


  # filters
  $scope.filterNonArchived = (note) ->
    return not note.archived

  $scope.filterArchived = (note) ->
    return note.archived


  # parse url, render the page
  stateChanged = () ->
    switch $state.current.name
      when 'notes'
        Storage.selectCategory null
        # break
      # when 'notes.category'
        # Storage.selectCategory $stateParams.categoryId, (err) ->
          # $window.location.hash = "/" if err
      # when 'notes.note'
        # Storage.selectCategory $stateParams.categoryId, (err) ->
        #   if err
        #     $window.location.hash = "/"
        #     return
        #   Storage.selectNote $stateParams.noteId, (err) ->
        #     $window.location.hash = "/#{$stateParams.categoryId}" if err
    true

  # events
  $scope.$on 'newNoteSaved', (event, note) ->
    if note is Storage.currentNote
      $state.go 'notes.category.note',
        categoryId: Storage.currentCategory.objectId
        noteId: Storage.currentNote.objectId

  # init controller
  # - load categories
  # - set the url change callback
  # - call the update page
  # Storage.loadCategories () ->
  $scope.$on '$stateChangeSuccess', stateChanged
  # stateChanged()

angular.module 'CMKeeper'
	.controller 'NotesCtrl', [
    '$scope',
    '$state',
    '$stateParams',
    '$window',
    'Storage',
    PageCtrl]
