module Glimmer_Tk_WidgetProxy_Override
  # due to some problem in Glimmer we can't make `to` a named argument
  # so it is a hash which expects only one key {to: <target>}
  def redirect_event(event_name, to = {})
    raise ArgumentError, "Specify redirect target as `to` argument" unless (target = to[:to])

    @redirected_events ||= {}

    on(event_name) do |event|
      if @redirected_events[event_name]&.include?(event.widget)
        raise RuntimeError, "Event #{event_name} was redirected to #{event.widget}, but bubbled up again. "\
                            "Use `on_redirected_event` or break false` to prevent that."
      end

      @redirected_events[event_name] ||= []
      @redirected_events[event_name] << target.tk

      target.raise_event(event_name, event.detail)
      break false
    end
  end

  def on_redirected_event(event_name, &block)
    on(event_name) { |event|
      block.call(event)
      break false
    }
  end

  def raise_event(event_name, data = nil)
    tk.event_generate("<#{event_name}>", data: (data.is_a?(Hash) ? data.to_yaml : data))
  end

  def grid(options = {})
    index_in_parent = griddable_parent_proxy&.children&.index(griddable_proxy)
    row_uniform     = options.delete(:row_uniform)
    column_uniform  = options.delete(:column_uniform)
    if index_in_parent
      case
      when row_uniform
        TkGrid.rowconfigure(griddable_parent_proxy.tk, index_in_parent, 'uniform' => row_uniform)
      when column_uniform
        TkGrid.columnconfigure(griddable_parent_proxy.tk, index_in_parent, 'uniform' => column_uniform)
      end
    end
    super
  end

  ::Glimmer::Tk::WidgetProxy.prepend self
end
