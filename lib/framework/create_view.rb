class Framework::CreateView
  include Callable

  class RecursiveViewCall < StandardError; end
  class TemplateNotFound < StandardError; end

  init_with_attributes :view_path, :args, :block

  def call
    # TODO: it may cause false alarms if called from different threads. Better solution?
    if ViewsBacktrace.instance.include?(view_path)
      raise RecursiveViewCall, "Template #{view_path} seems to be calling itself. "\
                               "Backtrace:\n   #{view_path}\n#{ViewsBacktrace.map { |view_path| "<- #{view_path}" }.join("\n") }"
    end
    ViewsBacktrace.push(view_path)

    view_abs_path = Framework.path('app/views').join("#{view_path}.glimmer.rb")
    raise TemplateNotFound, "Can't find template #{view_abs_path}" unless File.exist?(view_abs_path)

    view_model_abs_path = Framework.path('app/views').join("#{view_path}.rb")
    view_model_instance =
      if File.exist?(view_model_abs_path)
        view_model_class_name = 'ViewModels::' + view_path.to_s.split('/').map { |n| n.camelcase(:upper) }.join('::')
        view_model_class_name.safe_constantize&.new
      end

    view_model_name = File.basename(view_path)
    template_content = File.read(view_abs_path)

    CreateContainer
      .new(_container_type: container_type,
           _template_content: template_content,
           _view_model_name: view_model_name,
           _view_model_instance: view_model_instance,
           _header_block: block,
           _body_block: (Framework::Dev::Scene.scenario_for(view_path) if Framework::Dev::Scene.watched?))
      .instance_variable_get(:@_container)
      .tap { |container|
        Framework::Dev::Scene.patch_glimmer_container(container) if Framework::Dev::Scene.watched?
        ViewsBacktrace.pop
      }
  end

  private

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

  class ViewsBacktrace < Array
    include SingletonWithInstanceMethods

    def from_main_window?
      self.any? && self.first.to_s == 'main_window'
    end
  end

  class CreateContainer
    include Glimmer

    def initialize(_container_type:, _template_content:, _view_model_name:, _view_model_instance: nil,
                   _header_block: nil, _body_block: nil)
      define_instance_reader :view_model, _view_model_instance
      define_instance_reader _view_model_name, _view_model_instance

      if _container_type == :toplevel && !ViewsBacktrace.from_main_window?
        Views.MainWindow.content do
          @_container = send(_container_type) {
            define_instance_reader :view, self
            define_instance_reader :widget, self

            instance_exec(&_header_block) if _header_block
          }
        end

      else
        @_container = send(_container_type) {
          define_instance_reader :view, self
          define_instance_reader :widget, self

          instance_exec(&_header_block) if _header_block
        }
      end

      Framework::TemplateEvaluator.new(_container: @_container,
                                       _template_content: _template_content,
                                       _view_model_name: _view_model_name,
                                       _view_model_instance: _view_model_instance,
                                       _body_block: _body_block)
    end
  end

end
