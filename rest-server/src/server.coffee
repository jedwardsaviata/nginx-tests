require 'log-a-log'

{
  isNil
  map
} = require 'ramda'

joi = require 'joi'
express = require 'express'
durations = require 'durations'

identity = process.env.HOST_IDENTITY ? "rest"
port = process.env.BIND_PORT ? 8080

app = express()

app.use (req, res) ->
  {
    cookies
    headers
    hostname
    ip
    method
    originalUrl
    path
    protocol
    query
    secure
  } = req

  console.log """
  Method: #{method}
  Headers: #{JSON.stringify headers}
  """

  res.set('X-Host-Identity', identity).status(200).json
    identity: identity
    status: 'up'
    method: method
    headers: headers
    path: path
    query: query
    debug:
      originalUrl: originalUrl
      protocol: protocol
      secure: secure
      hostname: hostname
      ip: ip
      cookies: cookies

app.listen port, -> console.log "Listening on port #{port}"

