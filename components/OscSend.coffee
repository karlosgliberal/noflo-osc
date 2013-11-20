noflo = require "noflo"
chai = require "chai"
osc = require "../lib/omgosc"

class OscSend extends noflo.LoggingComponent
  constructor: ->
    @ip = null
    @puerto = null
    @msg = null
    @inPorts =
      ip: new noflo.Port
      puerto: new noflo.Port
      msg: new noflo.Port
    @outPorts =
      salida: new noflo.Port

    @inPorts.ip.on 'data', (data) =>
      @ip = data
    @inPorts.puerto.on 'data', (data) =>
      @puerto = data
    @inPorts.msg.on 'data', (data) =>
      @msg = data
      do @mensaje unless @msg is null

    @sendLog
      logLevel: "info"
      message: "Twitter REST API call finished successfully."
      request: @ip

  mensaje: ->
    sender = new osc.UdpSender(@ip, @puerto);
    sender.send(@msg);
    @outPorts.salida.send @msg
    @outPorts.salida.disconnect()

exports.getComponent = -> new OscSend

