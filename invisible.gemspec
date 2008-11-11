--- !ruby/object:Gem::Specification 
name: invisible
version: !ruby/object:Gem::Version 
  version: 0.0.1
platform: ruby
authors: 
- Marc-Andre Cournoyer
autorequire: 
bindir: bin
cert_chain: []

date: 2008-11-11 00:00:00 -05:00
default_executable: invisible
dependencies: 
- !ruby/object:Gem::Dependency 
  name: rack
  type: :runtime
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: 0.4.0
    version: 
- !ruby/object:Gem::Dependency 
  name: markaby
  type: :runtime
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0.5"
    version: 
description: Invisible is like a giant robot combining the awesomeness of Rails, Merb, Camping and Sinatra. Except, it's tiny (100 sloc).
email: macournoyer@gmail.com
executables: 
- invisible
extensions: []

extra_rdoc_files: 
- README
files: 
- README
- Rakefile
- invisible.gemspec
- bin/invisible
- lib/invisible
- lib/invisible/core_ext.rb
- lib/invisible/erb.rb
- lib/invisible/erubis.rb
- lib/invisible/haml.rb
- lib/invisible/helpers.rb
- lib/invisible/mock.rb
- lib/invisible/reloader.rb
- lib/invisible.rb
- app_generators/invisible
- app_generators/invisible/invisible_generator.rb
- app_generators/invisible/templates
- app_generators/invisible/templates/app.rb
- app_generators/invisible/templates/config
- app_generators/invisible/templates/config/boot.rb
- app_generators/invisible/templates/config/env
- app_generators/invisible/templates/config/env/development.rb
- app_generators/invisible/templates/config/env/production.rb
- app_generators/invisible/templates/config/env/test.rb
- app_generators/invisible/templates/config/env.rb
- app_generators/invisible/templates/config/rack.ru
- app_generators/invisible/templates/public
- app_generators/invisible/templates/public/stylesheets
- app_generators/invisible/templates/public/stylesheets/app.css
- app_generators/invisible/templates/public/stylesheets/ie.css
- app_generators/invisible/templates/public/stylesheets/print.css
- app_generators/invisible/templates/public/stylesheets/screen.css
- app_generators/invisible/templates/Rakefile
- app_generators/invisible/templates/script
- app_generators/invisible/templates/script/server.rb
- app_generators/invisible/templates/spec
- app_generators/invisible/templates/spec/app_spec.rb
- app_generators/invisible/templates/spec/spec_helper.rb
- app_generators/invisible/templates/views
- app_generators/invisible/templates/views/layout.erb
has_rdoc: true
homepage: http://github.com/macournoyer/invisible
post_install_message: 
rdoc_options: 
- --main
- README
require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
  version: 
required_rubygems_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
  version: 
requirements: []

rubyforge_project: 
rubygems_version: 1.2.0
signing_key: 
specification_version: 2
summary: The Invisible Web Framework
test_files: []

