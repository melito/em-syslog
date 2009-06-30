require "rubygems"
require "eventmachine"
require "socket"

module EventMachine
  module Protocols
    module Syslog
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
 
      class << self
        # THIEVERY: http://github.com/kpumuk/ruby_syslog    
        def log(severity, message, time = nil)
          raise "Syslog Server not set" if EM.syslog_server.nil?
          
          severity = SEVERITIES[severity] if severity.is_a? Symbol
          time ||= Time.now
          hostname = Socket.gethostname
          day = time.strftime('%b %d').sub(/0(\d)/, ' \\1')
          tag = "#{$0.split('/').last}[#{Process.pid}]"
          send_msg "<#{0 * 8 + severity}>#{day} #{time.strftime('%T')} #{hostname} #{tag}: #{message}"
        end

        def send_msg(data)
          EM.next_tick{
            EM.open_datagram_socket('0.0.0.0', 0) {|c| 
              c.send_datagram(data, EM.syslog_server, EM.syslog_port) 
            }
          }
        end              
      end
      
    end
  end
  
  class << self
    attr_reader :syslog_server, :syslog_port
    def syslog_setup(server, port=514)
      @syslog_server, @syslog_port = server, port
    end

    # THIEVERY: http://github.com/kpumuk/ruby_syslog
    EM::P::Syslog::SEVERITIES.keys.each do |severity|
      define_method severity do |message|
        EM::P::Syslog.log(severity, message)
      end
    end
    
  end

end  
