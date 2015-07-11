module Fatek
  class Worker
    attr_accessor :y0

    def initialize(ip)
      @ip = ip
      @queue = Queue.new
      @mutex = Mutex.new
    end

    def self.instance(ip = '192.168.1.3')
      @instance ||= new(ip)
    end

    def running?
      @thread && @thread.alive?
    end

    def start
      return if running?
      @mutex.synchronize do
        return if running?
        @thread = Thread.new do
          begin
            @plc = ModBus::TCPClient.new(@ip, 502).with_slave(0)
            @y0 = @plc.coils[0][0]
            loop do
              # Run commands in queue
              until @queue.empty?
                @queue.pop
              end

              # Read coil and broadcast new value if it has changed
              y0 = @plc.coils[0][0]
              if y0 != @y0
                WebsocketRails[:y0].trigger(:new, y0)
                @y0 = y0
              end

              sleep(0.1)
            end
          rescue
            sleep(5)
            retry
          end
        end
      end
    end

    def send(message)
      @queue << message
    end

    def self.send(message)
      Worker.instance.send(message)
    end

    def self.run
      Worker.send({command: '41', data: '1'})
    end

    def self.stop
      Worker.send({command: '41', data: '0'})
    end
  end
end
