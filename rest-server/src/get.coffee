require 'log-a-log'

axios = require 'axios'
{getPort} = require './get-port'

apiHost = process.env.API_SERVER_HOST ? 'localhost'
host = process.env.SWARM_MANAGER_IP ? apiHost

determinePort = ->
  apiPort = process.env.API_SERVER_PORT
  service = process.env.PROXY_SERVICE ? 'proxy-test_outer'

  if apiPort?
    new Promise (resolve) -> resolve parseInt(apiPort)
  else
    getPort
      serviceName: service
      targetPort: 8080

determinePort()
.then (port) ->
	axios.get "http://#{host}:#{port}/resource/bleh?q=wha&a=meh"
.then ({status, data}) ->
  console.log "[#{status}] #{JSON.stringify data, null, 2}"
.catch console.error

