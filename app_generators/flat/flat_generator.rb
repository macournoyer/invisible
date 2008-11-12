class FlatGenerator < RubiGen::Base
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
      
      # Templates
      m.template_copy_each %w( README )
      
      # Static files
      m.file_copy_each %w( app.rb
                           rack.ru )
    end
  end
  
  protected
    def banner
      <<-EOS
Creates a new Invisible app with just the minimum.

USAGE: invisible my_app --flat [options]
EOS
    end
    
    def add_options!(opts)
    end
    
    def extract_options
    end
end
