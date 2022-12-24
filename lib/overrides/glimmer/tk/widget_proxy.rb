module Glimmer_Tk_WidgetProxy_Override
  # TODO: RedirectEventExpression?
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

      widget = target.is_a?(Proc) ? target.call(event) : target

      @redirected_events[event_name] ||= []
      @redirected_events[event_name] << widget.tk

      widget.raise_event(event_name, event.detail)
      break false
    end
  end

  # TODO: OnRedirectedEventExpression?
  def on_redirected_event(event_name, &block)
    on(event_name) { |event|
      block.call(event)
      break false
    }
  end

  # TODO: RaiseEventExpression?
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
    @_visible = true
    super
  end

  # TODO: decide which one - `visible` or `hidden` - is more convenient to use (or just keep both?)

  def visible
    instance_variable_defined?(:@_visible) ? @_visible : (@_visible = true)
  end
  alias_method :visible?, :visible

  def visible=(value)
    value = !!value
    return if visible == value

    if value
      # grid column_weight: @_visible__column_weight, row_weight: @_visible__row_weight
      grid
    else
      # index_in_parent = griddable_parent_proxy&.children&.index(griddable_proxy)
      # @_visible__column_weight = TkGrid.columnconfiginfo(griddable_parent_proxy.tk, index_in_parent)['weight']
      # @_visible__row_weight    = TkGrid.rowconfiginfo(griddable_parent_proxy.tk, index_in_parent)['weight']
      # grid column_weight: 0, row_weight: 0
      tk.grid_remove
    end
    @_visible = value
  end

  def hidden
    !visible
  end
  alias_method :hidden?, :hidden

  def hidden=(value)
    self.visible = !value
  end

  # TODO: decide which one - `enabled` or `disabled` - is more convenient to use (or just keep both?)

  def enabled
    # puts "#{self.inspect}.enabled tk.state = \"#{tk.state}\""
    tk.state == 'normal'
  end

  def enabled=(value)
    tk.state = value ? 'normal' : 'disabled'
  end

  def disabled
    !enabled
  end

  def disabled=(value)
    # puts "#{self.inspect} disabled := #{value.to_s}"
    self.enabled = !value
  end

  def style=(style_name_or_styles)
    if style_name_or_styles.is_a? String
      @tk.style(style_name_or_styles)
    else
      super
    end
  end

  def destroy
    children.each(&:destroy)
    super
  end

  def unbind_all
    @listeners&.keys&.each do |key|
      if key.to_s.downcase.include?('command')
        @tk.send(key, '')
      else
        @tk.bind_remove(key)
      end
    end
    @listeners = nil
  end

  def clear!
    unbind_all
    children.each(&:destroy)
    @children = []
  end

  # TODO: fix it in Glimmer
  # https://github.com/AndyObtiva/glimmer-dsl-tk/blob/v0.0.62/lib/glimmer/tk/toplevel_proxy.rb#L43
  def grab_release
    @tk.grab_release
  end

  ::Glimmer::Tk::WidgetProxy.prepend self
end
