class Framework::RenderView
  include Glimmer
  include Framework::ViewHelpers
  include Callable

  class ErrorInTemplate < StandardError
    attr_accessor :container
    private :container=
    def initialize(msg = nil, failed_container)
      self.container = failed_container
      super(msg)
    end
  end

  init_with_attributes :_container,
                       :_view_path,
                       :_view_model_instance,
                       :_body_block

  def call
    define_instance_reader :view_model, _view_model_instance
    define_instance_reader File.basename(_view_path), _view_model_instance
    define_instance_reader :view, _container
    define_instance_reader :widget, _container

    Dir.glob(Framework.path('app/views')
                      .join("#{_view_path}_components/_*.glimmer.rb")).each do |component_abs_path|
      component_method_name = File.basename(component_abs_path, '.glimmer.rb').delete_prefix('_')
      eval "define_singleton_method :#{component_method_name} do\n#{File.read(component_abs_path)}\nend"
    end

    # TODO: _container.clear! ?
    begin
      _view_abs_path = Framework.path("app/views").join("#{_view_path}.glimmer.rb")
      _container.content do
        instance_eval(File.read(_view_abs_path))
        instance_exec(&_body_block) if _body_block
      end

    rescue StandardError, SyntaxError => e
      # (eval):8:in `block in initialize'
      line_before_eval = e.backtrace.find_index { |line| line.include?(__FILE__) }
      error_message = if line_before_eval.nil?
                        "Failed to render a view: #{e.class} / #{e} in #{_view_abs_path} (can't detect line number)"
                      else
                        failure_line_number = e.backtrace[line_before_eval - 1].split(':', 3)[1]
                        if failure_line_number&.match? /^[0-9]+$/
                          "Failed to render a view: #{e.class} / #{e} in #{_view_abs_path}:#{failure_line_number}"
                        else
                          "Failed to render a view: #{e.class} / #{e} in #{_view_abs_path} (can't detect line number)"
                        end
                      end
      puts error_message
      raise ErrorInTemplate.new(error_message, _container)
    else
      puts "Rendered #{_view_abs_path}"
    end
  end

end
