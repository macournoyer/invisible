class Invisible
  # Reloader all the code loaded using the Invisible#load method.
  # Use with the Reloader middleware.
  def reload!
    loaded = @loaded.uniq
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