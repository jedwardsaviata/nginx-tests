require 'log-a-log'

axios = require 'axios'
{getPort} = require './get-port'

host = process.env.SWARM_MANAGER_IP ? 'localhost'

getPort
	serviceName: 'proxy-test_outer'
	targetPort: 8080
.then (port) ->
	axios.get "http://#{host}:#{port}/"
.then ({status, data}) ->
  console.log "[#{status}] #{JSON.stringify data}"
.catch console.error

