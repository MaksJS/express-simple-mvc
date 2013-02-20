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
    route      = route.split /\s+/
    rest       = route[0].toLowerCase()
    url        = route[1]
    controller = route[2].match(/(.+)\.(\w+)$/)[1]
    method     = route[2].match(/(.+)\.(\w+)$/)[2]
    try
      controller = eval controller
      controller = new controller
    catch e 
      throw new Error "Controller '#{controller}' doesn't exists"
    throw new Error "Controller '#{controller}' doesn't have '#{method}' method" unless controller[method]?
    throw new Error "REST method '#{rest}' not supported" if rest not in ['get', 'post', 'put', 'delete', 'head', 'all']
    throw new Error "Invalid URL '#{url}' in routes" unless /^\/\w*/.test url
    app[rest] url, do (controller, method) -> (req, res) ->
      controller.req = req 
      controller.res = res
      do controller[method]

exports.simple_mvc = (app) ->
  getModels ->
    getControllers ->
      getRoutes (routes) ->
        parseRoutes app, routes