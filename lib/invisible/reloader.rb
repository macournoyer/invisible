class Invisible
  # Load an external file that will be reloaded
  def load(file)
    (@loaded ||= []) << file
    path = File.join(@root, file) + ".rb"
    eval(File.read(path), binding, path)
  end
  
  def reload!
    loaded = @loaded || []
    @loaded = []
    [@actions, @layouts, @views].each { |c| c.clear }
    loaded.each { |f| load(f) }
  end
  
  # Middleware to reload the app on each request
  class Reloader
    def initialize(app, reloadable)
      @app, @reloadable = app, reloadable
    end
    
    def call(env)
      @reloadable.reload!
      @app.call(env)
    end
  end
end