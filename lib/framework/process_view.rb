class Framework::ProcessView
  include Callable

  class TemplateNotFound < StandardError; end

  init_with_attributes :view_path, :args, :block

  def call
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

  def container_type
    case
    when main_window? then :root
    when window? then :toplevel
    else :frame
    end
  end

  def main_window?
    view_path.to_s == 'main_window'
  end

  def window?
    view_path.to_s.end_with?('_window')
  end

  class TemplateEvaluator
    include Glimmer

    def initialize(container_type:, template_content:, view_model_name:, view_model_instance: nil, block: nil)
      define_instance_reader :view_model, view_model_instance
      define_instance_reader view_model_name, view_model_instance

      if container_type == :toplevel
        Views.MainWindow.content do
          @evaluated = send(container_type) {
            define_instance_reader :view, self
            define_instance_reader :widget, self

            instance_exec(&block) if block
          }
        end

      else
        @evaluated = send(container_type) {
          define_instance_reader :view, self
          define_instance_reader :widget, self

          instance_exec(&block) if block
        }
      end

      define_instance_reader :view, @evaluated
      define_instance_reader :widget, @evaluated

      @evaluated.content do
        instance_eval(template_content)
      end
    end
  end

end
