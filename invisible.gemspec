Gem::Specification.new do |s|
  s.name        = "invisible"
  s.version     = "0.0.1"
  s.date        = "2008-11-08"
  s.summary     = "The Invisible Web Framework"
  s.email       = "macournoyer@gmail.com"
  s.homepage    = "http://github.com/macournoyer/invisible"
  s.description = "Invisible is like a giant robot combining the awesomeness of Rails, Merb, Camping and Sinatra. Except, it's tiny (100 sloc)."
  s.authors     = ["Marc-Andre Cournoyer"]
  s.files       = %w(README Rakefile invisible.gemspec) + Dir["{bin,lib,app_generators}/**/*"]
  
  # RDoc
  s.has_rdoc         = true
  s.rdoc_options     = ["--main", "README"]
  s.extra_rdoc_files = ["README"]
  
  # Dependencies
  s.add_dependency("rack",    [">= 0.4.0"])
  s.add_dependency("markaby", [">= 0.5"])
  
  # Binary
  s.bindir             = "bin"
  s.default_executable = "invisible"
  s.executables        = "invisible"
end