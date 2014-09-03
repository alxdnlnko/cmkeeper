gulp = require 'gulp'
rename = require 'gulp-rename'
uglify = require 'gulp-uglify'
streamify = require 'gulp-streamify'
gzip = require 'gulp-gzip'
gutil = require 'gulp-util'
stylus = require 'gulp-stylus'
express = require 'express'
jade = require 'gulp-jade'

browserify = require 'browserify'
through = require 'through2'
coffeeify = require 'coffeeify'
debowerify = require 'debowerify'

path = require 'path'
nib = require 'nib'

livereload = require 'gulp-livereload'


TARGETS =
  styles: ['src/styles/index.styl']
  scripts: ['src/scripts/app.coffee']
  templates: ['src/views/*.jade']


bundle = ->
  return through.obj (file, enc, cb) ->
    b = browserify entries: file.path, extensions: ['.coffee']
      .transform coffeeify
      .transform debowerify

    file.contents = b.bundle()
    this.push file
    cb()


gulp.task 'dev-scripts', ->
  gulp.src TARGETS.scripts
    .pipe bundle()
    .pipe rename 'app.min.js'
    .pipe gulp.dest 'public/js/'
    .pipe livereload()


gulp.task 'build-scripts', ->
  gulp.src ['client/scripts/**/app.coffee']
    .pipe bundle()
    .pipe rename 'app.min.js'
    .pipe streamify uglify()
    .pipe streamify gzip append: false
    .pipe gulp.dest 'public/js/'


gulp.task 'styles', ->
  gulp.src TARGETS.styles
    .pipe stylus
      paths: [nib.path]
      set: ['compress']
    .pipe rename 'style.min.css'
    .pipe gulp.dest 'public/css/'
    .pipe livereload()


gulp.task 'templates', ->
  gulp.src TARGETS.templates
    .pipe jade pretty: false
    .pipe gulp.dest 'public/'
    .pipe livereload()


gulp.task 'express', ->
  app = express()
  app.use require('connect-livereload')()
  app.use '/', express.static path.resolve './public'
  app.listen 3000
  gutil.log 'Listening on 3000'


gulp.task 'watch', ->
  livereload.listen()
  gulp.watch ['src/scripts/**/*.coffee'], ['dev-scripts']
  gulp.watch ['src/styles/**/*.styl'], ['styles']
  gulp.watch TARGETS.templates, ['templates']


gulp.task 'default', ['dev-scripts', 'styles', 'templates', 'express', 'watch']
