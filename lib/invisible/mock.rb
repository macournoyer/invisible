class Invisible
  class Mock
    def initialize(app)
      @app = app
    end
    
    def process(method, path, options={})
      Rack::MockResponse.new *@app.call(Rack::MockRequest.env_for("/", options.merge(:method => method)))
    end
    HTTP_METHODS.each { |m| class_eval "def #{m}(p, o={}); process('#{m.to_s.upcase}', p, o) end" }
  end
  
  def mock
    @mock ||= Mock.new(self)
  end
end