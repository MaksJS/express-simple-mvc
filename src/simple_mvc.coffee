exports.simple_mvc = (app, dirControllers, dirModels, dirRoutes) ->
  fs = require 'fs'
  # Getting models
  require dirModels + '/' + model for model in fs.readdirSync dirModels
  # Getting controllers
  require dirControllers + '/' + controller for controller in fs.readdirSync dirControllers
  # Getting routes
  routes = fs.readFileSync dirRoutes, 'utf8'
  # Parsing routes
  for route in routes.split('\n') when route.match /^[A-Z]/
    route      = route.split /\s+/
    rest       = route[0].toLowerCase()
    url        = route[1]
    method     = route[2]
    try
      method = eval method
    catch e 
      throw new Error "Method '#{route[2]}' doesn't exists"
    throw new Error "REST method '#{rest}' not supported" if rest not in ['get', 'post', 'put', 'delete', 'head', 'all']
    throw new Error "Invalid URL '#{url}' in routes" unless /^\/\w*/.test url
    app[rest] url, do (controller, method) -> (req, res) -> method req, res