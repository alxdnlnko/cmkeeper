require 'angular'
require 'angular-ui-router'

# hack for marked lib
# (author didn't update a bower package)
window.marked = require '../../bower_components/marked/lib/marked.js'
require 'angular-marked'

require '../../bower_components/ace-builds/src-min-noconflict/ace.js'
require '../../bower_components/ace-builds/src-min-noconflict/mode-markdown.js'
require '../../bower_components/ace-builds/src-min-noconflict/theme-tomorrow.js'
require 'angular-ui-ace'
require 'angular-animate'

angular.module 'CMKeeper', [
  'ui.router',
  'hc.marked',
  'ui.ace',
  'ngAnimate'
]

angular.module 'CMKeeper'
  .config [
    'markedProvider',
    (markedProvider) ->
      markedProvider.setOptions
        gfm: true
        tables: true
        breaks: true
        pedantic: true
        sanitize: true
        smartLists: true
        smartypants: true
  ]

angular.module 'CMKeeper'
  .config [
    '$animateProvider',
    ($animateProvider) ->
      $animateProvider.classNameFilter /.*cm-animated.*/
  ]

require './models'
require './controllers'
require './services'
require './directives'
require './routes'
