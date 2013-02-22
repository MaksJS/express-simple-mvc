express      = require 'express'
mongoose     = require 'mongoose'
{simple_mvc} = require 'express-simple-mvc'
require 'namespace'

app = express()
app.listen 3000

app.configure ->
  app.use express.methodOverride()
  app.use app.router

simple_mvc app, __dirname + '/controllers', __dirname + '/models', __dirname + '/config/routes'

mongoose.connect 'mongodb://127.0.0.1:27017/test', (err) -> 
  if err then throw err