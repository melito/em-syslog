require "lib/em/syslog"
require "test/unit"

module DumbTestHelpers
  SYSLOG_SERVER = '0.0.0.0'
  SYSLOG_PORT   = 514
  
  # FIXME Assume epoll if we're not on Darwin
  def set_io_notification_facility_for_platform(platform)
    if platform.downcase.include?("darwin")
      EM.kqueue
    else
      EM.epoll
    end
  end

  def method_missing(method_sym, *args, &block)
    # If you call stop_after_10_ticks a timer will be created that will call EM.stop after 10 seconds
    if method_sym.to_s =~ /stop_after_(\d)_ticks/
      EM.add_timer($1.to_i) { EM.stop }
    end
  end
end

class EmSyslogDumbTests < Test::Unit::TestCase
  include DumbTestHelpers
  
  def setup
    set_io_notification_facility_for_platform(RUBY_PLATFORM)
  end

  def test_various_set_args
    assert_nothing_raised(ArgumentError) do
      EM.run { EM.syslog_setup(SYSLOG_SERVER); stop_after_1_ticks }
      EM.run { EM.syslog_setup(SYSLOG_SERVER, SYSLOG_PORT); stop_after_1_ticks }
      EM.run { EM.syslog_setup; stop_after_1_ticks }
    end
  end
  
end