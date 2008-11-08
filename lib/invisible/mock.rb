class Invisible
  def mock
    @mock ||= Rack::MockRequest.new(@app)
  end

  module MockMethods
    HTTP_METHODS.each { |m| module_eval "def #{m}(*a); @app.mock.#{m}(*a) end" }
  end
end