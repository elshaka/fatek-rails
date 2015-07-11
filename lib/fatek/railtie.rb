module Fatek
  class Railtie < Rails::Railtie
    config.after_initialize do |app|
      unless defined?(Rails::Console)
        Fatek::Worker.instance(app.config.modbus_ip).start
      end
    end
  end
end
