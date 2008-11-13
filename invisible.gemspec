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

date: 2008-11-12 00:00:00 -05:00
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
- app_generators/flat
- app_generators/flat/flat_generator.rb
- app_generators/flat/templates
- app_generators/flat/templates/app.rb
- app_generators/flat/templates/rack.ru
- app_generators/flat/templates/README
- app_generators/full
- app_generators/full/full_generator.rb
- app_generators/full/templates
- app_generators/full/templates/app.rb
- app_generators/full/templates/config
- app_generators/full/templates/config/boot.rb
- app_generators/full/templates/config/env
- app_generators/full/templates/config/env/development.rb
- app_generators/full/templates/config/env/production.rb
- app_generators/full/templates/config/env/test.rb
- app_generators/full/templates/config/env.rb
- app_generators/full/templates/config/rack.ru
- app_generators/full/templates/gitignore
- app_generators/full/templates/public
- app_generators/full/templates/public/stylesheets
- app_generators/full/templates/public/stylesheets/ie.css
- app_generators/full/templates/public/stylesheets/print.css
- app_generators/full/templates/public/stylesheets/screen.css
- app_generators/full/templates/Rakefile
- app_generators/full/templates/README
- app_generators/full/templates/spec
- app_generators/full/templates/spec/app_spec.rb
- app_generators/full/templates/spec/spec_helper.rb
- app_generators/full/templates/test
- app_generators/full/templates/test/app_test.rb
- app_generators/full/templates/test/test_helper.rb
- app_generators/full/templates/views
- app_generators/full/templates/views/layout.erb
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

