noflo = require "noflo"
chai = require "chai"
twitstream = require "../lib/omgosc"
querystring = require "querystring"


class Connect extends noflo.Component
  description: 'Conexion osc'
  constructor: ->
    @inPorts =
      ip: new noflo.Port 'string'
      connect: new noflo.Port 'bang'
    @outPorts =
      client: new noflo.Port 'object'

    @inPorts.ip.on 'data', (data) =>
      # Prepare options
      options = {}
      if typeof data is 'string'
        options.ip = data
      @connectDrone options

    @inPorts.connect.on 'data', =>
      @connectDrone {}

  connectDrone: (options) ->
    # Connect to the drone
    client = arDrone.createClient options

    # Pass it to the output port
    return unless @outPorts.client.isAttached()
    @outPorts.client.send client
    @outPorts.client.disconnect()

exports.getComponent = -> new Connect
