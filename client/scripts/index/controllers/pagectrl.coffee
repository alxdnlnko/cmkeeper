require 'angular'


PageCtrl = ($scope) ->
  $scope.test = 'Hello, Yo-Ho-Ho!'
  $scope.categories = [
    'Входящие'
    'Reliablehosting.com'
    'Идеи'
    'Разное'
  ]
  $scope.currentCategory = 'Входящие'

  $scope.notes = [
    {name: 'WHMCS автоматизация', archived: false, content: 'ladjflasdf lkjasdfkh,mcnxzv lkasjdfkasdf'}
    {name: 'Some note', archived: false, content: '123123123 12 312 3123123123 '}
    {name: 'Third note about birds', archived: false, content: 'birds are the best!'}
    {name: 'Hahahah thailand!', archived: true, content: 'We are going to Thailand!'}
    {name: 'Some old note', archived: true, content: 'archived note :)'}
    {name: 'Current available note', archived: false, content: 'Not archived note! ;)'}
  ]
  $scope.currentNote = $scope.notes[0]

  $scope.showNonArcihved = true
  $scope.showArcihved = true

  $scope.isEditing = false

  # events
  $scope.selectCategory = (category) ->
    $scope.currentCategory = category
    $scope.currentNote = $scope.notes[0]

  $scope.selectNote = (note) ->
    $scope.currentNote = note

  $scope.toggleNonArchived = () ->
    $scope.showNonArcihved = not $scope.showNonArcihved

  $scope.toggleArchived = () ->
    $scope.showArcihved = not $scope.showArcihved


  # filters
  $scope.filterNonArchived = (category) ->
    return not category.archived

  $scope.filterArchived = (category) ->
    return category.archived

angular.module 'cmIndex'
	.controller 'PageCtrl', ['$scope', PageCtrl]
