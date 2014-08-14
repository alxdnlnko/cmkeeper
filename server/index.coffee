express = require 'express'
morgan = require 'morgan'
bodyParser = require 'body-parser'
methodOverride = require 'method-override'

path = require 'path'

module.exports = app = express()

app.set 'views', path.resolve './views'
app.set 'view engine', 'jade'

app.use morgan('dev')
app.use require('connect-livereload')()

app.use '/public', express.static path.resolve './public'
app.use bodyParser.urlencoded extended: true
app.use bodyParser.json()
app.use methodOverride()


app.get '/', (req, res) ->
  res.render 'index'

# app.get '*.min.js', (req, res, next) ->
#   res.set 'Content-Encoding', 'gzip'
#   next()
