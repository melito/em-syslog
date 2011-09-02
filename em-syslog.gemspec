Gem::Specification.new do |s|
  s.name = "em-syslog"
  s.version = "0.0.2"
  s.date = "2009-06-30"
  s.authors = ["Mel Gray"]
  s.email = "melgray@gmail.com"
  s.has_rdoc = false
  s.summary = "Simple syslog integration into EventMachine at the class level."
  s.homepage = "http://www.github.com/melito/em-syslog"
  s.description = "Simple syslog integration into EventMachine at the class level."
  s.files = ["README",
             "lib/em/syslog.rb",
             "test/em_syslog_test.rb"]
  s.add_dependency('eventmachine')
  s.add_development_dependency('rake')
  s.add_development_dependency('minitest')
  s.add_development_dependency('em-ventually')
end
