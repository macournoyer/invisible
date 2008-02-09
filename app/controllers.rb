module Invisible
  class HomeController < Controller
    def index
      @title = 'Hi there!'
      @msg = 'You like my framework?'
    end
  end
end