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


api = express.Router()

# CATEGORIES API
api.route '/categories'
  .post (req, res) ->
    # create a new category
    res.json {}
  .get (req, res) ->
    console.log 'get categories!'
    # get all categories for current user
    res.json [
      {id: 'aaaaa', name: 'Входящие'}
      {id: 'bbbbb', name: 'Reliablehosting.com'}
      {id: 'ccccc', name: 'Идеи'}
      {id: 'ddddd', name: 'Разное'}
    ]

api.route '/categories/:categoryId'
  .all (req, res, next) ->
    # find and check :categoryId
    # return error code
    next()
  .get (req, res) ->
    # get a category with :categoryId
    res.json {success: true}
  .put (req, res) ->
    # update the category
    res.json {success: true}
  .delete (req, res) ->
    # delete the category
    res.json {success: true}


# NOTES API
api.route '/categories/:categoryId/notes'
  .post (req, res) ->
    # create a new note for category with :categoryId
    res.json {success: true}
  .get (req, res) ->
    # get all notes for category with :categoryId
    res.json {success: true}

api.route '/categories/:categoryId/notes/:noteId'
  .all (req, res, next) ->
    # find :categoryId and :noteId
    # return status code
    next()
  .get (req, res) ->
    # get a note with :noteId from :categoryId
    res.json {success: true}
  .put (req, res) ->
    # update the note
    res.json {success: true}
  .delete (req, res) ->
    # delete the note
    res.json {success: true}

app.use '/api', api





# app.get '/api/category', (req, res) ->
  # res.send [
  #   {id: 'aaaaa', name: 'Входящие'}
  #   {id: 'bbbbb', name: 'Reliablehosting.com'}
  #   {id: 'ccccc', name: 'Идеи'}
  #   {id: 'ddddd', name: 'Разное'}
  # ]


# app.get '/api/category/:categoryId/note', (req, res) ->
#   res.send [
#     {id: '1111', name: 'WHMCS автоматизация', archived: false, content: 'ladjflasdf lkjasdfkh,mcnxzv lkasjdfkasdf'}
#     {id: '2222', name: 'Some note', archived: false, content: '123123123 12 312 3123123123 '}
#     {id: '3333', name: 'Third note about birds', archived: false, content: 'birds are the best!'}
#     {id: '4444', name: 'Hahahah thailand!', archived: true, content: 'We are going to Thailand!'}
#     {id: '5555', name: 'Some old note', archived: true, content: 'archived note :)'}
#     {id: '6666', name: 'Current available note', archived: false, content: 'Not archived note! ;)'}
#   ]

# app.get '*.min.js', (req, res, next) ->
#   res.set 'Content-Encoding', 'gzip'
#   next()
