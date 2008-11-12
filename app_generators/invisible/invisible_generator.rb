class InvisibleGenerator < RubiGen::Base
  attr_reader :name
  
  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @destination_root = File.expand_path(args.shift)
    @name = base_name
    extract_options
  end
  
  def manifest
    record do |m|
      # Root directory and all subdirectories.
      m.directory ''
      m.directory 'config'
      m.directory 'config/env'
      m.directory 'lib'
      m.directory 'public'
      m.directory 'public/stylesheets'
      m.directory 'public/javascripts'
      m.directory 'public/images'
      m.directory 'views'
      
      # Default module for app
      m.template_copy_each %w( README Rakefile )
      
      # Static files
      m.file_copy_each %w( app.rb
                           config/boot.rb
                           config/env/production.rb
                           config/env/development.rb
                           config/env/test.rb
                           config/env.rb
                           config/rack.ru
                           public/stylesheets/ie.css
                           public/stylesheets/print.css
                           public/stylesheets/screen.css
                           views/layout.erb )
      
      if options[:rspec]
        m.directory 'spec'
        m.file_copy_each %w( spec/spec_helper.rb
                             spec/app_spec.rb )
      else # Test::Unit
        m.directory 'test'
        m.file_copy_each %w( test/test_helper.rb
                             test/test_spec.rb )
      end
      
      if options[:git]
        m.file "gitignore", ".gitignore"
      end
    end
  end
  
  protected
    def banner
      <<-EOS
Creates a new Invisible app.

USAGE: #{spec.name} name
EOS
    end
    
    def add_options!(opts)
      opts.separator ''
      opts.separator 'Options:'
      opts.on("-S", "--rspec",   "Use RSpec for testing (default to Test::Unit)") { |options[:rspec]| }
      opts.on("-g", "--git",     "Add Git stuff (default: true)") { |options[:git]| }
    end
    
    def extract_options
      # for each option, extract it into a local variable (and create an "attr_reader :author" at the top)
      # Templates can access these value via the attr_reader-generated methods, but not the
      # raw instance variable value.
      # @author = options[:author]
    end
end
