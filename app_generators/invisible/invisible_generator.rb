class InvisibleGenerator < RubiGen::Base
  
  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])
  
  
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
      m.directory 'public'
      m.directory 'public/stylesheets'
      m.directory 'public/javascripts'
      m.directory 'public/images'
      m.directory 'spec'
      m.directory 'views'
      
      # Default module for app
      # m.template_copy_each %w()
      
      # Static files
      m.file_copy_each %w(Rakefile
                          app.rb
                          config/boot.ru
                          config/env/production.rb
                          config/env/development.rb
                          config/env/test.rb
                          spec/app_spec.rb
                          views/layout.erb)
      
      # Scripts
      m.dependency "install_rubigen_scripts", [destination_root, 'invisible'],
        :shebang => options[:shebang], :collision => :force
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
      # For each option below, place the default
      # at the top of the file next to "default_options"
      # opts.on("-a", "--author=\"Your Name\"", String,
      #         "Some comment about this option",
      #         "Default: none") { |options[:author]| }
      opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
    end

    def extract_options
      # for each option, extract it into a local variable (and create an "attr_reader :author" at the top)
      # Templates can access these value via the attr_reader-generated methods, but not the
      # raw instance variable value.
      # @author = options[:author]
    end
end
