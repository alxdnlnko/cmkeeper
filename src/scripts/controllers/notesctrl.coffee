NotesCtrl = ($scope, $state, $stateParams, $window, $rootScope, Storage) ->
  # hack to hide preloader after all reloves
  $rootScope.hideGlobalPreloader = true

  $scope.storage = Storage

  $scope.showNonArcihved = true
  $scope.showArcihved = true
  $scope.categoriesOrder = 'created'
  $scope.isNoteMenuVisible = false

  $scope.isCategoryDialogVisible = false
  $scope.editedCategoryName = null

  $scope.focusEditor = false

  $scope.showCategoryDialog = () ->
    return if not Storage.currentCategory
    $scope.isCategoryDialogVisible = true

  $scope.hideCategoryDialog = () ->
    $scope.isCategoryDialogVisible = false

  $scope.editCategory = () ->
    return if not Storage.currentCategory
    $scope.editedCategoryName = Storage.currentCategory.name
    $scope.showCategoryDialog()

  $scope.cancelEditingCategory = () ->
    $scope.editedCategoryName = null
    $scope.hideCategoryDialog()

  $scope.saveEditedCategory = () ->
    return if not Storage.currentCategory or not $scope.editedCategoryName
    cat = Storage.currentCategory
    cat.name = $scope.editedCategoryName
    cat.save()

    $scope.editedCategoryName = null
    $scope.hideCategoryDialog()

  $scope.showNoteMenu = () ->
    $scope.isNoteMenuVisible = true

  $scope.hideNoteMenu = () ->
    $scope.isNoteMenuVisible = false

  $scope.aceLoaded = (ace) ->
    ace.setHighlightActiveLine false
    ace.setShowPrintMargin false
    ace.setWrapBehavioursEnabled true
    # ace.commands.addCommand
    #   name: 'toggleVimMode'
    #   bindKey: win: 'Ctrl-Shift-V', mac: 'Command-Option-V'
    #   exec: (editor) ->
    #     editor.setKeyboardHandler 'vim'
    ace.commands.addCommand
      name: 'removeLine'
      bindKey: win: 'Ctrl-X'
      exec: (editor) ->
        editor.removeLines()
    ace.commands.addCommand
      name: 'saveNote'
      bindKey: win: 'Ctrl-S'
      exec: (editor) ->
        $scope.saveEditing()
    ace.commands.addCommand
      name: 'cancelEditing'
      bindKey: win: 'Escape'
      exec: (editor) ->
        $scope.$apply () ->
          $scope.cancelEditing()

  # UI handlers
  $scope.toggleNonArchived = () ->
    $scope.showNonArcihved = not $scope.showNonArcihved

  $scope.toggleArchived = () ->
    $scope.showArcihved = not $scope.showArcihved

  $scope.archiveNote = () ->
    Storage.archiveNote()

  $scope.unarchiveNote = () ->
    Storage.unarchiveNote()

  $scope.deleteNote = () ->
    if confirm "Are you sure want to delete the note?"
      Storage.deleteNote()

  $scope.startEditing = () ->
    Storage.startEditing()

  $scope.saveEditing = () ->
    note = Storage.currentNote
    if not $scope.focusEditor and not note.objectId and not note.editedContent
      $scope.focusEditor = true
      return
    $scope.focusEditor = false
    Storage.saveEditing()

  $scope.cancelEditing = () ->
    Storage.cancelEditing()


  $scope.addNote = () ->
    $scope.focusEditor = false
    $state.transitionTo 'notes.category', categoryId: Storage.currentCategory.objectId
      .then () ->
        Storage.addNote()

  $scope.addCategory = () ->
    Storage.addCategory()

  $scope.saveCategory = () ->
    Storage.saveNewCategory()

  $scope.cancelNewCategory = () ->
    Storage.cancelNewCategory()


  # filters
  $scope.filterNonArchived = (note) ->
    return not note.archived

  $scope.filterArchived = (note) ->
    return note.archived


  # keyEvents
  $scope.newCategoryInputKey = (ev) ->
    switch ev.keyCode
      when 27
        $scope.cancelNewCategory()

  $scope.editNoteInputKey = (ev) ->
    switch ev.keyCode
      when 27
        $scope.cancelEditing()

  $scope.editCategoryInputKey = (ev) ->
    switch ev.keyCode
      when 27
        $scope.cancelEditingCategory()

  # parse url, render the page
  stateChanged = () ->
    switch $state.current.name
      when 'notes'
        Storage.selectCategory null
      when 'notes.category'
        Storage.selectNote null

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
    '$rootScope',
    'Storage',
    NotesCtrl]
