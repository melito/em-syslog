require "lib/em/syslog"

SYSLOG_SERVER = '0.0.0.0'
SYSLOG_PORT   = 123456

# EM.kqueue
# EM.epoll
EM.run {
  
  # This is gonna be our 'syslog' server for testing to make sure we're getting the correct packets
  EM.open_datagram_socket SYSLOG_SERVER, SYSLOG_PORT do |c|
    def c.receive_data data
      p data      
    end
  end
  
  @logger = EM.syslog_server(SYSLOG_SERVER, SYSLOG_PORT)
  EM.add_periodic_timer(1) {
    @logger.alert("#{Time.now.to_s}")
  }
  
}