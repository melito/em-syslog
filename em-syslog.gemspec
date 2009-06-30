Gem::Specification.new do |s|
  s.name = "em-syslog"
  s.version = "0.0.1"
  s.date = "2009-06-30"
  s.authors = ["Mel Gray"]
  s.email = "melgray@gmail.com"
  s.has_rdoc = false
  s.summary = "Simple syslog integration into EventMachine at the class level."
  s.homepage = "http://www.github.com/melito/em-syslog"
  s.description = "Simple syslog integration into EventMachine at the class level."
  s.files = ["README",
             "lib/em/syslog.rb",
             "test.rb"]
  s.add_dependency('eventmachine')
end