class Object
  class << self

    def init_with_attributes(*attributes)
      attr_internal_accessor *attributes

      define_method :initialize do |*args|
        puts "Initialize #{attributes.pretty_inspect} with #{args.pretty_inspect}"
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

  end

  def define_instance_reader(name, value)
    define_singleton_method name do
      value
    end
  end

end
