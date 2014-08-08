gulp = require 'gulp'
rename = require 'gulp-rename'
uglify = require 'gulp-uglify'
streamify = require 'gulp-streamify'
gzip = require 'gulp-gzip'
gutil = require 'gulp-util'

browserify = require 'browserify'
through = require 'through2'
coffeeify = require 'coffeeify'
debowerify = require 'debowerify'

express = require 'express'
path = require 'path'


bundle = ->
  return through.obj (file, enc, cb) ->
    b = browserify entries: file.path, extensions: ['.coffee']
      .transform coffeeify
      .transform debowerify

    file.contents = b.bundle()
    this.push file
    cb()


gulp.task 'dev-scripts', ->
  gulp.src ['client/scripts/**/app.coffee']
    .pipe bundle()
    .pipe rename (path) ->
      path.basename = path.dirname + '.min'
      path.dirname = ''
      path.extname = '.js'
      return path
    .pipe gulp.dest 'public/js/'


gulp.task 'build-scripts', ->
  gulp.src ['client/scripts/**/app.coffee']
    .pipe bundle()
    .pipe rename (path) ->
      path.basename = path.dirname + '.min'
      path.dirname = ''
      path.extname = '.js'
      return path
    .pipe streamify uglify()
    .pipe streamify gzip append: false
    .pipe gulp.dest 'public/js/'


gulp.task 'express', ->
  app = express()
  app.get '*.min.js', (req, res, next) ->
    res.set 'Content-Encoding', 'gzip'
    next()
  app.use express.static path.resolve './public'
  app.listen 3000
  gutil.log 'Listening on port 3000'


gulp.task 'default', ['dev-scripts', 'express']
