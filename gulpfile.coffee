gulp = require 'gulp'
rename = require 'gulp-rename'
uglify = require 'gulp-uglify'
streamify = require 'gulp-streamify'
gzip = require 'gulp-gzip'
gutil = require 'gulp-util'
stylus = require 'gulp-stylus'
# express = require 'gulp-express'

browserify = require 'browserify'
through = require 'through2'
coffeeify = require 'coffeeify'
debowerify = require 'debowerify'

path = require 'path'
nib = require 'nib'

livereload = require 'gulp-livereload'


TARGETS =
  styles: ['client/styles/index.styl']
  scripts: ['client/scripts/**/app.coffee']
  server: ['server/**/*.coffee']


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
    .pipe rename (path) ->
      path.basename = path.dirname + '.min'
      path.dirname = ''
      path.extname = '.js'
      return path
    .pipe gulp.dest 'public/js/'
    .pipe livereload()


gulp.task 'build-scripts', ->
  gulp.src ['client/scripts/**/app.coffee']
    .pipe bundle()
    .pipe rename (path) ->
      path.basename += '.min'
      path.dirname = ''
      path.extname = '.js'
      return path
    .pipe streamify uglify()
    .pipe streamify gzip append: false
    .pipe gulp.dest 'public/js/'


gulp.task 'styles', ->
  gulp.src TARGETS.styles
    .pipe stylus
      paths: [nib.path]
      set: ['compress']
    .pipe rename (path) ->
      path.basename += '.min'
      path.dirname = ''
      path.extname = '.css'
      return path
    .pipe gulp.dest 'public/css/'
    .pipe livereload()


gulp.task 'express', ->
  # express.run file: './app.js'
  app = require './server'
  app.listen 3000
  gutil.log 'Listening on 3000'


gulp.task 'watch', ->
  livereload.listen()
  gulp.watch ['client/scripts/**/*.coffee'], ['dev-scripts']
  gulp.watch ['client/styles/**/*.styl'], ['styles']


gulp.task 'default', ['dev-scripts', 'styles', 'express', 'watch']
