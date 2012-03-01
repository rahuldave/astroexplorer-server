###
A NodeJS server that statically serves javascript out, proxies solr requests,
and handles authentication through the ADS
###

connect = require 'connect'
connectutils = connect.utils
http = require 'http'
querystring = require 'querystring'
url = require 'url'
fs = require 'fs'
redis=require('redis')
###### BRING BACK THIS LATER ##########
#redis_client = redis.createClient()
# RedisStore = require('connect-redis')(connect)

requests = require "./requests"
completeRequest = requests.completeRequest
failedRequest = requests.failedRequest
successfulRequest = requests.successfulRequest
ifLoggedIn = requests.ifLoggedIn
postHandler = requests.postHandler
postHandlerWithJSON = requests.postHandlerWithJSON

proxy = require "./proxy"

#migration = require('./migration2')

config = require("./config").config
SITEPREFIX = config.SITEPREFIX
STATICPREFIX = config.STATICPREFIX

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


doPost = (func) ->
  (req, res, next) -> postHandler req, res, func

doPostWithJSON = (func) ->
  (req, res, next) -> postHandlerWithJSON req, res, func
# Proxy the call to ADS, setting up the NASA_ADS_ID cookie


server = connect.createServer()
#server.use connect.logger()
server.use connect.cookieParser()
server.use connect.query()

server.use SITEPREFIX+'/solr/', solrrouter
server.use SITEPREFIX+'/solr2/', solrrouter2



runServer = (svr, port) ->
  now = new Date()
  hosturl = "http://localhost:#{port}#{SITEPREFIX}"
  console.log "#{now.toUTCString()} - Starting server on #{hosturl}"
  svr.listen port

runServer server, config.PORT

