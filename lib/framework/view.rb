class Framework::View
  include Callable

  class TemplateNotFound < StandardError; end

  init_with_attributes :view_path

  def call
    view_abs_path = Framework.path('app/views').join("#{view_path}.glim.rb")
    raise TemplateNotFound, "Can't find template #{view_abs_path}" unless File.exist?(view_abs_path)

    view_model_abs_path = Framework.path('app/views').join("#{view_path}.rb")
    view_model_instance =
      if File.exist?(view_model_abs_path)
        view_model_class_name  = view_path.split('/').map { |n| n.camelcase(:upper) }.join('::')
        view_model_class_name.safe_constantize&.new
      end

    view_model_name = File.basepath(view_path)
    template_content = File.read(view_abs_path)

    TemplateEvaluator.new(template_content, view_model_name, view_model_instance)
  end

  class TemplateEvaluator
    include Glimmer

    def initialize(template_content, view_model_name, view_model_instance = nil)
      # define_instance_reader :views, Framework::ViewSelector.new
      define_instance_reader :view_model, view_model_instance
      define_instance_reader view_model_name, view_model_instance

      instance_eval(template_content)
    end

    def method_missing(method_symbol, *args, &block)
      Framework::ViewSelector.new().send(method_symbol)
    end
  end

end