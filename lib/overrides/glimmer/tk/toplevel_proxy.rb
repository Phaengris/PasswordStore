module Glimmer_Tk_ToplevelProxy_Override

  def modal
    center_within_root
    root_parent_proxy.withdraw
    tk.grab_set
    on('WM_DELETE_WINDOW') do
      tk.grab_release
      root_parent_proxy.deiconify
      destroy
      true
    end
    on('destroy') do
      tk.grab_release
      root_parent_proxy.deiconify
      true
    end
  end

  def center_within_root(options = {})
    margin = options[:margin] || 0

    if margin.zero?
      self.x = root_parent_proxy.x
      self.y = root_parent_proxy.y
      self.width = root_parent_proxy.width
      self.height = root_parent_proxy.height
    else
      self.x = root_parent_proxy.x + margin
      self.y = root_parent_proxy.y + margin
      self.width = root_parent_proxy.width - 2 * margin
      self.height = root_parent_proxy.height - 2 * margin
    end
  end

  ::Glimmer::Tk::ToplevelProxy.prepend self
end
