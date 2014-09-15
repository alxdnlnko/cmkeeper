require 'angular'
require 'angular-ui-router'

window.marked = require '../../bower_components/marked/lib/marked.js'
require './highlight.js'

require '../../bower_components/ace-builds/src-min-noconflict/ace.js'
require '../../bower_components/ace-builds/src-min-noconflict/mode-markdown.js'
require '../../bower_components/ace-builds/src-min-noconflict/theme-tomorrow.js'
require 'angular-ui-ace'
require 'angular-animate'

angular.module 'CMKeeper', [
  'ui.router',
  'ui.ace',
  'ngAnimate'
]

require './models'
require './controllers'
require './services'
require './directives'
require './routes'

angular.module 'CMKeeper'
  .config [
    '$animateProvider',
    ($animateProvider) ->
      $animateProvider.classNameFilter /.*cm-animated.*/
  ]
