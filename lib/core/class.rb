module ClassPatch

  module ClassMethods
    def init_with_attributes(*attributes)
      attr_internal_accessor *attributes

      define_method :initialize do |**args|
        args.each do |attr, val|
          raise ArgumentError, "Unexpected attribute `#{attr}`" unless attributes.include?(attr)

          send("#{attr}=", val)
        end
      end
    end
  end

  module InstanceMethods
    def define_instance_reader(name, value)
      define_singleton_method name do
        value
      end
    end
  end

end

Class.extend ClassPatch::ClassMethods
Class.include ClassPatch::InstanceMethods

