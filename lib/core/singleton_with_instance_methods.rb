module SingletonWithInstanceMethods

  def self.included(base)
    base.include Singleton
    base.class_eval do
      # private_class_method :instance

      def self.method_missing(name, *args, &block)
        return instance.send(name, *args, &block) if instance.respond_to?(name)
        super
      end
    end
  end

end