_ = require 'lodash'
exec = require './exec'

# Fetch the service details from the swarm
inspectService = (serviceName) ->
  exec "docker service inspect #{serviceName}"
  .then ({stdout}) -> JSON.parse stdout

# Determine the exposed port for this service
getPort = (args) ->
  config =
    serviceName: args.serviceName ? 'proxy-test_outer'
    targetPort: args.targetPort ? 8080

  inspectService config.serviceName
  .then (tasks) ->
    _(tasks ? [])
    .map (task) ->
      _(task?.Endpoint?.Ports ? [])
      .map ({TargetPort, PublishedPort}) ->
        target: TargetPort
        published: PublishedPort
      .filter ({target}) -> target == config.targetPort
      .first()
    .filter (port) -> port?
    .map ({published}) -> published
    .first()

# Runs in CLI mode
runScript = ->
  # Parse the arguments passed in from the CLI
  args = require 'yargs'
    # Full service name <stack>_<service>
    .string 'serviceName'
    # The port exposed by the service to which the
    # published port forwards
    .number 'targetPort'
    # Extract the arguments
    .argv

  getPort args
  .then (publishedPort) ->
    if publishedPort?
      console.log publishedPort
      process.exit 0
    else
      process.exit 1
  .catch (error) ->
    console.error "Error determining exposed port:", error
    process.exit 1

module.exports =
  getPort: getPort
  runScript: runScript

if require.main == module
  runScript()

