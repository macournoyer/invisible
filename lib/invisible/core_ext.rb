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
  #   x = Foo::Bar.subclass('Zap'){}
  #   x.name # => Foo::Bar::Zap_1
  #   x.superclass.name # => Foo::Bar
  def subclass(base_name, &body)
    klass = Class.new(self)
    class_name = "#{base_name}_#{class_count!}"
    instance_eval do
      const_set(class_name, klass)
    end
    klass.instance_eval(&body)
    klass
  end

  private
    def class_count!
      @class_count ||= 0
      @class_count += 1
      @class_count
    end
end
