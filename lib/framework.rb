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

  def self.exit
    # TODO: may be some exit handlers
    Kernel.exit
  end
end

require_relative './framework/views'
require_relative './framework/view_models'