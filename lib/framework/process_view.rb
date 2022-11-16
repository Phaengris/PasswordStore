class Framework::ProcessView
  include Callable

  class TemplateNotFound < StandardError; end

  init_with_attributes :view_path, :args, :block

  def call
    puts "Path #{view_path}, args #{args.pretty_inspect}, block #{block.pretty_inspect}"

    view_abs_path = Framework.path('app/views').join("#{view_path}.glimmer.rb")
    raise TemplateNotFound, "Can't find template #{view_abs_path}" unless File.exist?(view_abs_path)

    view_model_abs_path = Framework.path('app/views').join("#{view_path}.rb")
    view_model_instance =
      if File.exist?(view_model_abs_path)
        view_model_class_name  = 'ViewModels::' + view_path.to_s.split('/').map { |n| n.camelcase(:upper) }.join('::')
        view_model_class_name.safe_constantize&.new
      end

    view_model_name = File.basename(view_path)
    template_content = File.read(view_abs_path)

    TemplateEvaluator
      .new(container_type: container_type,
           template_content: template_content,
           view_model_name: view_model_name,
           view_model_instance: view_model_instance,
           block: block)
      .instance_variable_get(:@evaluated)
  end

  def window?
    view_path.to_s.end_with?('_window')
  end

  def container_type
    window? ? :root : :frame
  end

  class TemplateEvaluator
    include Glimmer

    def initialize(container_type:, template_content:, view_model_name:, view_model_instance: nil, block: nil)
      define_instance_reader :view_model, view_model_instance
      define_instance_reader view_model_name, view_model_instance

      @evaluated = send(container_type) {
        block.call if block
      }
      define_instance_reader :view, @evaluated
      define_instance_reader :this, @evaluated
      @evaluated.content do
        instance_eval(template_content)
      end
    end
  end

end
