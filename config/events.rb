WebsocketRails.setup do |config|
  # Enable channel synchronization between multiple server instances.
  # * Requires Redis.
  config.synchronize = true
end

WebsocketRails::EventMap.describe do
  subscribe :client_connected, to: SCADAController, with_method: :client_connected
  subscribe :client_disconnected, to: SCADAController, with_method: :client_disconnected
  subscribe :ping, to: SCADAController, with_method: :ping
  subscribe :run, to: SCADAController, with_method: :run
  subscribe :stop, to: SCADAController, with_method: :stop
end