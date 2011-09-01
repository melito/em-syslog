Gem::Specification.new do |s|
  s.name = "em-syslog"
  s.version = "0.0.2"
  s.date = "2011-09-01"
  s.authors = ["Mel Gray", "Sean Porter"]
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