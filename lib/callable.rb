module Callable

  def self.included(base)
    base.class_eval do
      class << self
        def call(*args)
          self.new(*args).call
        end
      end
    end
  end

end