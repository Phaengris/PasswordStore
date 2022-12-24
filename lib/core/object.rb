require 'memoized'

class Object
  include Memoized

  class << self

    def init_with_attributes(*attributes)
      attr_internal_accessor *attributes

      define_method :initialize do |*args|
        args = args.first if args.is_a?(Array) && args.one? && args.first.is_a?(Hash)

        case args
        when Hash
          args.each do |attr, val|
            raise ArgumentError, "Unexpected attribute `#{attr}`" unless attributes.include?(attr)

            send("#{attr}=", val)
          end
        when Array
          if args.count > attributes.count
            raise ArgumentError,
                  "Expected only #{attributes.count} #{"argument".pluralize(attributes.count)}, got #{args.count}"
          end

          attributes.each_with_index { |attr, i| send("#{attr}=", args[i]) }
        else
          raise ArgumentError, "Sorry, not sure how to process #{args.pretty_inspect}"
        end
      end
    end

    def on_attr_write(attr, &block)
      unless instance_methods(false).include?("#{attr}=".to_sym)
        raise ArgumentError,
              "Writer for attr `#{attr}` is not defined. Use `attr_writer :#{attr}` or `attr_accessor :#{attr}` to define it."
      end
      if instance_methods(false).include?("#{attr}_value=".to_sym)
        raise ArgumentError,
              "`on_attr_write` handler for attr `#{attr}` is already defined. Multiple handlers aren't supported at the moment."
      end

      alias_method "#{attr}_value=", "#{attr}="

      define_method "#{attr}=" do |value|
        previous_value = send(attr) if respond_to?(attr)
        send("#{attr}_value=", value)
        instance_exec(value, previous_value, &block)
      end
    end
  end

  def define_instance_reader(name, value)
    define_singleton_method name do
      value
    end
  end

  def _debug(msg = nil, data = {})
    # return unless Framework::Dev::Scene.watched?

    puts <<-DEBUG.squish.strip
      DEBUG:
      #{self.class.to_s}#{self.is_a?(Class) ? '.' : '#'}#{Kernel.caller.first.match(/in `([^']+)'/)[1]}
      #{msg}
      #{data.map { |key, value| "#{key} = \"#{value.inspect}\""}.join(' ')}
    DEBUG
  end

end
