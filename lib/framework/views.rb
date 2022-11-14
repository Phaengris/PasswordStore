module Views
  def method_missing(method_symbol, *args, &block)
    Framework::ViewSelector.new.send(method_symbol)
  end
end
