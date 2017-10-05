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

app.get '/', (req, res) ->
  {
    method
    headers
  } = req

  console.log """
  Method: #{method}
  Headers: #{JSON.stringify headers}
  """

  res.set('X-Host-Identity', identity).status(200).json
    status: 'good'

app.listen port, -> console.log "Listening on port #{port}"

