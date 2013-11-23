noflo = require "noflo"
chai = require "chai"

class OscMatch extends noflo.LoggingComponent
  constructor: ->
    @path = null
  
    @inPorts =
      in: new noflo.Port
      path: new noflo.Port

    @outPorts =
      out: new noflo.Port
      missed: new noflo.Port
    
    @inPorts.path.on 'data', (data) =>
      @path = data
      
    @inPorts.in.on 'data', (data) =>
      if @path is null
        @sendMatchedData data
      else if data.path is @path
        @sendMatchedData data
      else
        if @outPorts.missed.isAttached()
          @outPorts.missed.send data
          @outPorts.missed.disconnect()
   

    @inPorts.in.on "disconnect", =>
      @outPorts.out.disconnect() if @outPorts.out.isAttached()
      @outPorts.missed.disconnect() if @outPorts.missed.isAttached()
  sendMatchedData: (data) ->
    if @outPorts.out.isAttached()
     @outPorts.out.send data
     @outPorts.out.disconnect()

exports.getComponent = -> new OscMatch

