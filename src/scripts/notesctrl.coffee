require './storage'


PageCtrl = ($scope, $state, $stateParams, $window, Storage) ->
  $scope.storage = Storage

  $scope.showNonArcihved = true
  $scope.showArcihved = true


  # UI handlers
  $scope.toggleNonArchived = () ->
    $scope.showNonArcihved = not $scope.showNonArcihved

  $scope.toggleArchived = () ->
    $scope.showArcihved = not $scope.showArcihved

  $scope.startEditing = (note) ->
    Storage.startEditing()

  $scope.saveEditing = () ->
    Storage.saveEditing()

  $scope.cancelEditing = () ->
    Storage.cancelEditing()

  $scope.addNote = () ->
    $window.location.hash = "/#{Storage.currentCategory.id}"
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
        break
      when 'notes.category'
        Storage.selectCategory $stateParams.categoryId, (err) ->
          $window.location.hash = "/" if err
      when 'notes.note'
        Storage.selectCategory $stateParams.categoryId, (err) ->
          if err
            $window.location.hash = "/"
            return
          Storage.selectNote $stateParams.noteId, (err) ->
            $window.location.hash = "/#{$stateParams.categoryId}" if err
    true

  # events
  $scope.$on 'newNoteSaved', (event, note) ->
    if note == Storage.currentNote
      $window.location.hash = "/#{Storage.currentCategory.id}/#{note.id}"

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
