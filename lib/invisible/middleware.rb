module Invisible
  class TypeAgnosticBody
    def initialize(body)
      @body = body
    end
    
    def size
      case @body
      when Rack::Response
        TypeAgnosticBody.new(@body.body).size
      when String
        @body.size
      when Array
        @body.inject(0) { |sum, chunk| sum += chunk.size }
      else
        size = 0
        @body.each { |chunk| size += chunk.size }
        size
      end
    end
    
    def to_s
      case @body
      when Rack::Response
        TypeAgnosticBody.new(@body.body).to_s
      when String
        @body
      when Array
        @body.join("/n")
      else
        body_string = ""
        @body.each { |chunk| body_string << chunk }
        body_string
      end
    end
  end
end