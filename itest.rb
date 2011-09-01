# Interactive Test
# Automated tests kind of suck at the moment so this is here to ensure that data sent from the client
# will be received in the format that we expect
require "lib/em/syslog"

SYSLOG_SERVER = '0.0.0.0'
SYSLOG_PORT   = 3005

EM.run {
  
  # This is gonna be our 'syslog' server for testing to make sure we're getting the correct packets
  EM.open_datagram_socket SYSLOG_SERVER, SYSLOG_PORT do |c|
    def c.receive_data data
      p data      
    end
  end

  EM.syslog_setup(SYSLOG_SERVER, SYSLOG_PORT)
  
  EM.add_periodic_timer(1) {    
    
    EM.emergency('system is unusable')
    EM.alert('action must be taken immediately')
    EM.critical('critical conditions')
    EM.error('error conditions')
    EM.warning('warning conditions')
    EM.notice('normal but significant conditions')
    EM.informational('informational messages')
    EM.info('informational messages (short name for the previous)')
    EM.debug('debug-level messages')
  } 
  
}
