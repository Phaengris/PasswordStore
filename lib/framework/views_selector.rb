class Framework::ViewsSelector
  init_with_attributes :path

  def method_missing(name, *args, &block)
    next_path = path ? Pathname.new(path).join(name.to_s) : Pathname.new(name.to_s)

    if File.exist?(Framework.path("app/views/#{next_path}.glimmer.rb"))
      return Framework::CreateView.call(next_path, args, block)
    end

    if Dir.exist?(Framework.path("app/views/#{next_path}"))
      return self.class.new(next_path)
    end

    super
  end

end