NotesCtrl = ($scope, $state, $stateParams, $window, $rootScope, Storage) ->
  # hack to hide preloader after all reloves
  $rootScope.hideGlobalPreloader = true

  $scope.storage = Storage

  $scope.showNonArcihved = true
  $scope.showArcihved = true
  $scope.categoriesOrder = 'created'
  $scope.isCategoryDialogVisible = false
  $scope.editedCategoryName = null
  $scope.focusEditor = false



  # categories
  $scope.categoryAdd = () ->
    Storage.categoryAdd()

  $scope.categorySaveNew = () ->
    Storage.categorySaveNew()

  $scope.categoryCancelNew = () ->
    Storage.categoryCancelNew()

  $scope.categoryShowDialog = () ->
    return if not Storage.currentCategory
    $scope.isCategoryDialogVisible = true

  $scope.categoryHideDialog = () ->
    $scope.isCategoryDialogVisible = false

  $scope.categoryEdit = () ->
    return if not Storage.currentCategory
    $scope.editedCategoryName = Storage.currentCategory.name
    $scope.categoryShowDialog()

  $scope.categorySaveEdited = () ->
    return if not Storage.currentCategory or not $scope.editedCategoryName
    cat = Storage.currentCategory
    cat.name = $scope.editedCategoryName
    cat.save()

    $scope.editedCategoryName = null
    $scope.categoryHideDialog()

  $scope.categoryCancelEdited = () ->
    $scope.editedCategoryName = null
    $scope.categoryHideDialog()



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



  # filters
  $scope.filterNonArchived = (note) ->
    return not note.archived

  $scope.filterArchived = (note) ->
    return note.archived



  # keyEvents
  $scope.newCategoryInputKey = (ev) ->
    switch ev.keyCode
      when 27
        $scope.categoryCancelNew()

  $scope.editNoteInputKey = (ev) ->
    switch ev.keyCode
      when 27
        $scope.cancelEditing()

  $scope.editCategoryInputKey = (ev) ->
    switch ev.keyCode
      when 27
        $scope.categoryCancelEdited()



  # state events
  stateChanged = () ->
    switch $state.current.name
      when 'notes'
        Storage.selectCategory null
      when 'notes.category'
        Storage.selectNote null
    true



  # events
  $scope.$on 'newNoteSaved', (event, note) ->
    if note is Storage.currentNote
      $state.go 'notes.category.note',
        categoryId: Storage.currentCategory.objectId
        noteId: Storage.currentNote.objectId
  $scope.$on '$stateChangeSuccess', stateChanged



  # ace editor configuration
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
    ace.commands.addCommand
      name: 'togglecheckboxlistitem'
      bindKey: win: 'Ctrl-Shift-C'
      exec: (editor) ->
        range = editor.getSelectionRange()
        isBackwards = editor.selection.isBackwards()
        selectionStart = if isBackwards then editor.selection.getSelectionLead() else editor.selection.getSelectionAnchor()
        selectionEnd = if isBackwards then editor.selection.getSelectionAnchor() else editor.selection.getSelectionLead()

        inserting = null
        for i in [selectionStart.row..selectionEnd.row]
          curLine = editor.session.doc.getLine i
          continue if not /^\s*-/.test curLine

          range.setStart i, 0
          range.setEnd i, curLine.length

          if inserting is null
            if /^\s*- \[.\]\s*/.test curLine
              inserting = false
            else
              inserting = true

          if inserting and not /^\s*- \[.\]\s*/.test curLine
            editor.session.doc.replace range, curLine.replace /- /, '- [ ] '
          else if not inserting and /^\s*- \[.\]\s*/.test curLine
            editor.session.doc.replace range, curLine.replace /- \[ \]/, '-'

    rebindKeys = (name, keys) ->
      cmd = ace.commands.commands['movelinesdown']
      cmd.bindKey.win = 'Ctrl-Shift-down'
      ace.commands.addCommand cmd

    rebindKeys 'movelinesdown', 'Ctrl-Shift-down'
    rebindKeys 'movelinesup', 'Ctrl-Shift-up'
    rebindKeys 'copylinesup', 'Ctrl-Shift-enter'


angular.module 'CMKeeper'
	.controller 'NotesCtrl', [
    '$scope',
    '$state',
    '$stateParams',
    '$window',
    '$rootScope',
    'Storage',
    NotesCtrl]
