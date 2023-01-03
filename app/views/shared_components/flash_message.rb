class ViewModels::SharedComponents::FlashMessage
  attr_accessor :visible,
                :style,
                :text,
                :timeout,
                :timeout_step_delay

  def initialize
    self.visible = Concurrent::AtomicBoolean.new(false)
    self.text = Concurrent::AtomicReference.new
    self.timeout = Concurrent::AtomicFixnum.new
    self.timeout_step_delay = Concurrent::AtomicReference.new
  end

  def success(text)
    show('success', text)
  end

  def info(text)
    show('info', text)
  end

  def alert(text)
    show('alert', text)
  end

  def exception_alert(e, text = nil)
    text ||= 'Sorry, failed to do it.'
    alert "#{text} Application says:\n#{e.class}: #{e}"
  end

  private

  def show(style, text)
    self.visible.value = true
    self.style = style
    self.text.value = text
    self.timeout.value = 100
    self.timeout_step_delay.value = style == 'alert' ? 0.075 : 0.025 # more time to read error messages

    Thread.new do
      begin
        sleep self.timeout_step_delay.value
        self.timeout.value = self.timeout.value - 1
      end until self.timeout.value == 0
      self.visible.value = false
    end
  end

end