$: << File.dirname(__FILE__) + '/../lib' unless $:.include?(File.dirname(__FILE__) + '/../lib/')
require 'minitest/autorun'
require 'em-ventually/minitest'
require 'thread'
require 'socket'
require 'em/syslog'

SYSLOG_SERVER = 'localhost'
SYSLOG_PORT = 5140

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

$socket_queue = Queue.new
Thread.new do
  socket = UDPSocket.new
  socket.bind(SYSLOG_SERVER, SYSLOG_PORT)
  while true
    $socket_queue.push(socket.recvfrom(1024))
  end
end

class TestEMSylog < MiniTest::Unit::TestCase
  EM::Ventually.total_default = 0.5

  SEVERITIES.each do |severity, pri|
    define_method "test_#{severity.to_s}" do
      message = ''
      EM.syslog_setup(SYSLOG_SERVER, SYSLOG_PORT)
      EM.method(severity).call(severity.to_s)
      EM.defer(proc { $socket_queue.pop }, proc { |data| message = data.first })
      eventually(true) { message.include?("<#{pri.to_s}>") }
    end
  end

  def test_domain_socket
    EM.syslog_setup()
  end
end
