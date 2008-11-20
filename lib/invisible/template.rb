module Invisible
  class Template
    class NotFound < StandardError
      def initialize(name, format, paths)
        super "Could not find a template for #{name}.#{format} in #{paths.join(', ')}"
      end
    end
    
    class NoEngine < StandardError
      def initialize(engine)
        super "No engine registered to render #{engine}"
      end
    end
    
    # Locate templates
    class Locator
      attr_reader :paths
      
      def initialize(paths=[])
        @paths = paths
      end
      
      def locate(name, format)
        @paths.each do |path|
          if file = Dir["#{path}/#{name}.#{format}.*"].first
            return Template.new(file, format)
          end
        end
        raise NotFound.new(name, format, @paths)
      end
    end
    
    attr_reader :path, :format, :engine
    
    @@engines = {}
    def self.register_engine(engine, *exts)
      exts.each do |ext|
        @@engines[ext.to_s] = engine
      end
    end
    
    def initialize(path, format)
      @path   = path
      @format = format
      @engine = File.extname(@path)[1..-1]
    end
    
    def read
      File.read(@path)
    end
    
    def render(context)
      if engine = @@engines[@engine]
        engine.render(read, context)
      else
        raise NoEngine.new(@engine)
      end
    end
  end
end