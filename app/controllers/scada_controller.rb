class SCADAController < WebsocketRails::BaseController
  def initialize_session
    logger.debug 'Session initialized'
  end

  def client_connected
    logger.debug("Client #{client_id} connected")
  end

  def client_disconnected
    logger.debug("Client #{client_id} disconnected")
  end

  def ping
    trigger_success message
  end

  def run
    Fatek::Worker.run()
  end

  def stop
    Fatek::Worker.stop()
  end
end