module Views
  class MainWindowTemplateNotFoundError < StandardError; end
  class MainWindowAsComponentError < StandardError; end

  def self.MainWindow
    @main_window ||= begin
                       unless File.exist?(Framework.path('app/views/main_window.glimmer.rb'))
                         raise MainWindowTemplateNotFoundError, 'app/views/main_window.glimmer.rb must exist'
                       end
                       Framework::ProcessView.call(Pathname.new('main_window'))
                     end
  end

  def self.main_window
    raise MainWindowAsComponentError, "You can't create a main window component. Use Views.MainWindow to call the main window instance."
  end

  def self.method_missing(name, *args, &block)
    Framework::ViewSelector.new.send(name, *args, &block)
  end
end
