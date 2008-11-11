Gem::Specification.new do |s|
  s.name        = "invisible"
  s.version     = "0.0.1"
  s.date        = "2008-11-08"
  s.summary     = "The Invisible Web Framework"
  s.email       = "macournoyer@gmail.com"
  s.homepage    = "http://github.com/macournoyer/invisible"
  s.description = "Invisible is like a giant robot combining the awesomeness of Rails, Merb, Camping and Sinatra. Except, it's tiny (100 sloc)."
  s.authors     = ["Marc-Andre Cournoyer"]
  s.files       = %w(
    README
    Rakefile
    invisible.gemspec
    bin/invisible
    lib/invisible
    lib/invisible/core_ext.rb
    lib/invisible/erb.rb
    lib/invisible/erubis.rb
    lib/invisible/haml.rb
    lib/invisible/helpers.rb
    lib/invisible/mock.rb
    lib/invisible/reloader.rb
    lib/invisible.rb
    app_generators/invisible
    app_generators/invisible/invisible_generator.rb
    app_generators/invisible/templates
    app_generators/invisible/templates/app.rb
    app_generators/invisible/templates/config
    app_generators/invisible/templates/config/boot.rb
    app_generators/invisible/templates/config/env
    app_generators/invisible/templates/config/env/development.rb
    app_generators/invisible/templates/config/env/production.rb
    app_generators/invisible/templates/config/env/test.rb
    app_generators/invisible/templates/config/env.rb
    app_generators/invisible/templates/config/rack.ru
    app_generators/invisible/templates/public
    app_generators/invisible/templates/public/stylesheets
    app_generators/invisible/templates/public/stylesheets/app.css
    app_generators/invisible/templates/public/stylesheets/ie.css
    app_generators/invisible/templates/public/stylesheets/print.css
    app_generators/invisible/templates/public/stylesheets/screen.css
    app_generators/invisible/templates/Rakefile
    app_generators/invisible/templates/script
    app_generators/invisible/templates/script/server.rb
    app_generators/invisible/templates/spec
    app_generators/invisible/templates/spec/app_spec.rb
    app_generators/invisible/templates/spec/spec_helper.rb
    app_generators/invisible/templates/views
    app_generators/invisible/templates/views/layout.erb
  )
  
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