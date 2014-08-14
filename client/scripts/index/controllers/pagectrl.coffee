require 'angular'


PageCtrl = ($scope) ->
  $scope.test = 'Hello, Yo-Ho-Ho!'

angular.module 'cmIndex'
	.controller 'PageCtrl', ['$scope', PageCtrl]
