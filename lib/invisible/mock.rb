class Invisible
  # Return a mocked request for the app.
  # See: http://rack.rubyforge.org/doc/classes/Rack/MockRequest.html
  def mock
    @mock ||= Rack::MockRequest.new(@app)
  end
  
  # Contains methods to call each HTTP method on @app.
  # 
  #   get("/") # Will call @app.mock.get("/")
  #   session[:user] # Will call @app.session[:user]
  # 
  module MockMethods
    HTTP_METHODS.each { |m| module_eval "def #{m}(*a); @app.mock.#{m}(*a) end" }
    
    # Delegate some request helpers to the app
    def session; @app.session end
    def params;  @app.params end
  end
end