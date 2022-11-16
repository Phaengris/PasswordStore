module Glimmer_Tk_WidgetProxy_Override

  # due to some problem in Glimmer we can't make `to` a named argument
  # so it is a hash which expects only one key {to: <target>}
  def redirect_event(event_name, to = {})
    raise ArgumentError, "Specify redirect target as `to` argument" unless (target = to[:to])

    @redirected_events ||= {}

    on(event_name) do |event|
      if @redirected_events[event_name]&.include?(event.widget)
        raise RuntimeError, "Event #{event_name} has been sent to #{event.widget}, but returned"
      end

      @redirected_events[event_name] ||= []
      @redirected_events[event_name] << target.tk

      target.tk.event_generate("<#{event_name}>", data: event.detail)
      break false
    end
  end

  ::Glimmer::Tk::WidgetProxy.prepend self
end