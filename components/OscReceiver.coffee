noflo = require "noflo"
chai = require "chai"
osc = require "../lib/omgosc"

class OscReceiver extends noflo.LoggingComponent
  constructor: ->
    @host = null
    @port = null
    
    @msg = null
    
    @receiver = null
    
    @inPorts =
      host: new noflo.Port
      port: new noflo.Port
    @outPorts =
      out: new noflo.Port

    @inPorts.host.on 'data', (data) =>
      @host = data
      do @startServer unless @port is null
    @inPorts.port.on 'data', (data) =>
      @port = data
      do @startServer unless @host is null
  #  @inPorts.msg.on 'data', (data) =>
    #  @msg = data
     # do @mensaje unless @msg is null

    @sendLog
      logLevel: "info"
      message: ""
      request: @host, @port
  startServer: ->
    receiver = new osc.UdpReceiver(@port, @host)
    receiver.on '', (data) => @gotMessage data
      
  gotMessage: (data) ->
    @msg = data
    @outPorts.out.send @msg
    @outPorts.out.disconnect()

exports.getComponent = -> new OscReceiver

