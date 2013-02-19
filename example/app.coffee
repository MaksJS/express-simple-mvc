express      = require 'express'
mongoose     = require 'mongoose'
{simple_mvc} = require 'express-simple-mvc'
require 'namespace'

app = express()
app.listen 3000
simple_mvc app

app.configure ->
  app.use express.methodOverride()
  app.use app.router

mongoose.connect 'mongodb://127.0.0.1:27017/test', (err) -> 
  if err then throw err