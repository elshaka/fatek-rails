$ ->
  window.scadaController = new SCADA.Controller($('#scada').data('uri'), true);

window.SCADA = {}

class SCADA.Controller
  constructor: (url, @useWebSockets) ->
    @open = false
    @dispatcher = new WebSocketRails(url, @useWebSockets)
    @dispatcher.on_open = =>
      @open = true
    @y0 = @dispatcher.subscribe('y0')
    @bindEvents()

  bindEvents: ->
    @y0.bind('new', @new_y0)
    $('#run').click(@run)
    $('#stop').click(@stop)
    setTimeout(@check, 500)
    setInterval(@ping, 1000)

  check: =>
    unless @open
      if @useWebSockets
        window.scadaController = new SCADA.Controller(@dispatcher.url, false)

  new_y0: (value) ->
    $('#Y0').prop('checked', value)

  run: =>
    @dispatcher.trigger('run')

  stop: =>
    @dispatcher.trigger('stop')

  ping: =>
    @dispatcher.trigger('ping', (new Date).getTime(), (time) ->
      $('#console').html("Ping: #{(new Date).getTime() - time} ms")
    )