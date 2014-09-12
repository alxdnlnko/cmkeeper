require 'angular'
require 'angular-ui-router'

# hack for marked lib
# (author didn't update a bower package)
window.marked = require '../../bower_components/marked/lib/marked.js'
require 'angular-marked'
require './highlight.js'

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
      renderer = new marked.Renderer()

      # live checkboxes
      renderer.listitem = (text) ->
        nestedInd = text.indexOf '<ul>'
        nested = if nestedInd > -1 then text.slice nestedInd else ''
        text = text.replace nested, ''

        if /^\s*\[[x ]\]\s*/.test text
          text = text
            .replace /^\s*\[x\]\s*/, "<input type=\"checkbox\" checked>"
            .replace /^\s*\[ \]\s*/, "<input type=\"checkbox\">"
          return "<li class=\"checkbox-item js-checkbox-item\"><label>#{text}</label>#{nested}</li>"
        return "<li>#{text}#{nested}</li>"

      markedProvider.setOptions
        gfm: true
        tables: true
        breaks: true
        pedantic: true
        sanitize: true
        smartLists: true
        smartypants: true
        highlight: (code) ->
          hljs.highlightAuto(code).value
        renderer: renderer
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
