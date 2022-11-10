module ModulePatch
  class AttrMethodNameCollision < StandardError; end

  def self.included(base)
    base.class_eval do

      def attr_internal_reader(attr)
        raise ArgumentError, "Expected attribute name, given #{attr.pretty_print_inspect}" unless attr.is_a?(Symbol)
        raise AttrMethodNameCollision, "Method `#{attr}` already exists" if self.instance_methods.include?(attr)

        define_method(attr) do
          instance_variable_get("@#{attr}".to_sym)
        end
        private attr
      end

    end
  end
end

Module.include(ModulePatch)