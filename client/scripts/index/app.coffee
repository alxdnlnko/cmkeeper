require 'angular'
require 'angular-route'
require 'angular-resource'

angular.module 'cmIndex', [
  'ngRoute',
  'ngResource'
]

require './routes'
require './models'
require './pagectrl'
