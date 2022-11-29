class Framework::TemplateEvaluator
  include Glimmer

  def initialize(_container:, _template_content:, _view_model_name:, _view_model_instance: nil, _body_block: nil)
    define_instance_reader :view_model, _view_model_instance
    define_instance_reader _view_model_name, _view_model_instance
    define_instance_reader :view, _container
    define_instance_reader :widget, _container

    # TODO: _container.children.each(&:destroy) and _container.unbind_all ?
    _container.content do
      instance_eval(_template_content)
      instance_exec(&_body_block) if _body_block
    end
  end
end
