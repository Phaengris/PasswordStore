module Glimmer_Tk_ToplevelProxy_Override

  def center_within_root(options = {})
    margin = options[:margin] || 0

    self.x = root_parent_proxy.x + margin
    self.y = root_parent_proxy.y + margin
    self.width = root_parent_proxy.width - 2 * margin
    self.height = root_parent_proxy.height - 2 * margin
  end

  ::Glimmer::Tk::ToplevelProxy.prepend self
end
