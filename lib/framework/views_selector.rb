class Framework::ViewsSelector
  init_with_attributes :path

  def method_missing(name, *args, &block)
    next_path = path ? Pathname.new(path).join(name.to_s) : Pathname.new(name.to_s)
    puts "Framework::ViewsSelector path #{next_path}"

    if File.exist?(Framework.path("app/views/#{next_path}.glimmer.rb"))
      puts "  creating container"
      return Framework::CreateView.call(next_path, args, block)
    end

    if Dir.exist?(Framework.path("app/views/#{next_path}"))
      puts "  passing through"
      return self.class.new(next_path)
    end

    super
  end

end