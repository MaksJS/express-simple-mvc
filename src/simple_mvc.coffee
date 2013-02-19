fs = require 'fs'

getModels = (cb) ->
  fs.readdir './models', (err, files) ->
    if err then throw err
    require __dirname + '/../../../models/' + file for file in files
    do cb

getControllers = (cb) ->
  fs.readdir './controllers', (err, files) ->
    if err then throw err
    require __dirname + '/../../../controllers/' + file for file in files
    do cb

getRoutes = (cb) ->
  fs.readFile './config/routes', 'utf8', (err, routes) ->
    if err then throw err
    cb routes

parseRoutes = (app, routes) ->
  for route in routes.split('\n') when route.match /^[A-Z]/
    route  = route.split /\s+/
    rest   = route[0].toLowerCase()
    url    = route[1]
    Class  = route[2].match(/(.+)\.\w+$/)[1]
    method = route[2]
    try
      Class  = eval Class
      method = eval method
    catch e 
      throw new Error "Method '#{method}' doesn't exists"
    throw new Error "REST method '#{rest}' not supported" if rest not in ['get', 'post', 'put', 'delete', 'head', 'all']
    throw new Error "Invalid URL '#{url}' in routes" unless /^\/\w*/.test url
    app[rest] url, do (method) -> (req, res) ->
      Class.req = req 
      Class.res = res
      do method

exports.simple_mvc = (app) ->
  getModels ->
    getControllers ->
      getRoutes (routes) ->
        parseRoutes app, routes