class Invisible
  def mock
    @mock ||= Rack::MockRequest.new(@app)
  end
end