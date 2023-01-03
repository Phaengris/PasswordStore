module Framework
  def self.root
    @root ||= Pathname.new(File.expand_path(File.dirname(__FILE__) + '/..'))
  end

  def self.path(local_path)
    root.join(local_path)
  end

  def self.views_path
    path('app/views')
  end

  def self.view_path(path)
    views_path.join(path)
  end

  def self.assets_path
    path('app/assets')
  end

  def self.asset_path(path)
    assets_path.join(path)
  end

  def self.exit
    # TODO: exit callbacks?
    Views.MainWindow.destroy if Views.main_window_ready?
    Kernel.exit
  end
end

require_relative './framework/views'
require_relative './framework/view_models'