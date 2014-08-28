require 'angular'
require 'angular-ui-router'

angular.module 'CMKeeper', [
  'ui.router'
]

require './models'
require './loginctrl'
require './signupctrl'
require './notesctrl'
require './routes'
