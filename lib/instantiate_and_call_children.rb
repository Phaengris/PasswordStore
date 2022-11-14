module InstantiateAndCallChildren
  class CallMethodNotFound < StandardError; end

  def self.included(base)
    base.class_eval do
      class << self
        attr_internal_accessor :children_call_method
        prepend MethodMissing
      end
      self.children_call_method = :call
    end
  end

  module MethodMissing
    # TODO: `respond_to_missing?` isn't even called here... why?
    # def respond_to_missing?(m)
    # end

    def method_missing(m, *args)
      (super; return) unless m.match? /^[a-z0-9_]+$/
      child_class_name = m.to_s.camelcase(:upper)
      (super; return) unless self.const_defined?(child_class_name)

      child_class = self.const_get(child_class_name)
      unless child_class.instance_methods.include?(self.children_call_method)
        raise CallMethodNotFound, "#{child_class}##{self.children_call_method} method not found"
      end

      child_class.new(*args).send(self.children_call_method)
    end
  end

end