###
A NodeJS server that  proxies solr requests for now,
and handles caching nd all that, and ajax-solr server side, later
###

connect = require 'connect'
connectutils = connect.utils
#http = require 'http'
#querystring = require 'querystring'
#url = require 'url'
#fs = require 'fs'
#redis=require('redis')
###### BRING BACK THIS LATER ##########
#redis_client = redis.createClient()
# RedisStore = require('connect-redis')(connect)

proxy = require "./proxy"

#migration = require('./migration2')

#config = require("./config").config


configureServer = (config, server) -> 
  solrrouter = connect(
    connect.router (app) ->
      app.get '/select', (req, res) ->
        solroptions =
          host: config.SOLRHOST
          path: config.SOLRURL + req.url
          port: config.SOLRPORT
        proxy.doProxy solroptions, req, res
  )

  solrrouter2 = connect(
    connect.router (app) ->
      app.get '/select', (req, res) ->
        solroptions =
          host: config.SOLRHOST
          path: config.SOLRURL + req.url
          port: config.SOLRPORT2
        proxy.doProxy solroptions, req, res
  )
  #server = connect.createServer()
  #server.use connect.logger()
  #server.use connect.cookieParser()
  #server.use connect.query()
  server.use config.SITEPREFIX+'/solr/', solrrouter
  server.use config.SITEPREFIX+'/solr2/', solrrouter2



runServer = (config) ->
  console.log "CONFIG", config
  server = connect.createServer()
  server.use connect.logger()
  server.use connect.cookieParser()
  server.use connect.query()
  configureServer config, server
  now = new Date()
  hosturl = "http://localhost:#{config.PORT}#{config.SITEPREFIX}"
  console.log "#{now.toUTCString()} - Starting server on #{hosturl}"
  server.listen config.PORT

#runServer server, config.PORT
exports.configureServer = configureServer
exports.runServer = runServer

