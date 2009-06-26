require "rubygems"
require "eventmachine"
require "socket"

module EventMachine

  class << self
    # TODO: Thinking about fleshing this out a bit further to do things like EM.alert or EM.emergency
    def syslog_server(server='0.0.0.0', port=514)
      return Syslog.new(server, port)
    end
  end
    
  class Syslog
    attr_accessor :server, :port
  
    # THIEVERY: http://github.com/kpumuk/ruby_syslog
    SEVERITIES = {
      :emergency => 0,      # system is unusable
      :alert => 1,          # action must be taken immediately
      :critical => 2,       # critical conditions
      :error => 3,          # error conditions
      :warning => 4,        # warning conditions
      :notice => 5,         # normal but significant condition
      :informational => 6,  # informational messages
      :info => 6,           # informational messages (short name for the previous)
      :debug => 7           # debug-level messages
    }

    def initialize(server, port)
      @server, @port = server, port
    end

    # THIEVERY: http://github.com/kpumuk/ruby_syslog    
    def log(severity, message, time = nil)
      severity = SEVERITIES[severity] if severity.is_a? Symbol
      time ||= Time.now
      hostname = Socket.gethostname
      day = time.strftime('%b %d').sub(/0(\d)/, ' \\1')
      @tag = 'lulz'
      send "<#{0 * 8 + severity}>#{day} #{time.strftime('%T')} #{hostname} #{@tag}: #{message}"
    end
    
    def send(data)
      EM.next_tick {
        EM.open_datagram_socket('0.0.0.0', 0) {|c| c.send_datagram(data, @server, @port) }
      }
    end 

    # THIEVERY: http://github.com/kpumuk/ruby_syslog
    SEVERITIES.keys.each do |severity|
      define_method severity do |message|
        log(severity, message)
      end
    end

  end

end