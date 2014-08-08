require 'angular'

PageCtrl = require './controllers/pagectrl'

angular.module 'cmIndex', []
  .controller 'PageCtrl', ['$scope', PageCtrl]
