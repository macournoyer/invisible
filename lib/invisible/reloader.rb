class Invisible
  def reload!
    loaded = @loaded
    @loaded = []
    [@actions, @with, @layouts, @views].each { |c| c.clear }
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