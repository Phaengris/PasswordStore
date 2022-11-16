module Views
  def self.method_missing(name, *args, &block)
    Framework::ViewSelector.new.send(name, *args, &block)
  end
end
