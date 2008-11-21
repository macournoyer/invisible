module Invisible
  class Application
    extend Forwardable
    
    def_delegators :@context, :call
    
    attr_reader :template_locator
    
    def initialize(&block)
      @context = Context.create("/", &block)
      install_default_middlewares
    end
    
    private
      def install_default_middlewares
        @context.use Rack::Lint
        # @context.use Rack::MethodOverride
        @context.use Middleware::ContentLength
        @context.use Middleware::NormalizeBody
      end
  end
end