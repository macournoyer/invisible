# Mostly taken from ActiveSupport
unless defined?(ActiveSupport)
  class Hash
    # Return a new hash with all keys converted to symbols.
    def symbolize_keys
      inject({}) do |options, (key, value)|
        options[(key.to_sym rescue key) || key] = value
        options
      end
    end
  end
end

# Taken from RSpec
class Class
  # Creates a new subclass of self, with a name "under" our own name.
  # Example:
  #
  #   x = Foo::Bar.subclass('Zap')
  #   x.name # => Foo::Bar::Zap
  #   x.superclass.name # => Foo::Bar
  def subclass(class_name, &body)
    klass = Class.new(self)
    instance_eval do
      const_set(class_name, klass)
    end
    klass.instance_eval(&body) if body
    klass
  end
end
