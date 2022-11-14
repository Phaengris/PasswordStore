class Framework::ViewSelector
  init_with_attributes :path

  def method_missing(method_symbol, *args, &block)
    case
    when (supposed_templates_dir.present? then self.new(path: supposed_templates_dir)
    when supposed_template_file.present? then Framework::View.call(supposed_template_file)
    else
      super
    end
  end

end