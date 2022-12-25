class ViewModels::SharedComponents::FlashMessage
  attr_accessor :visible,
                :style,
                :text,
                :timeout

  def initialize
    self.visible = Concurrent::AtomicBoolean.new(false)
    self.text    = Concurrent::AtomicReference.new
    self.timeout = Concurrent::AtomicFixnum.new
  end

  def alert(text)
    show('alert', text)
  end

  # def exception(text, exception)
  #   show('alert', "#{text}#{'.' unless text[-1] == '.'} Application reports:\n#{exception.class}: #{exception}")
  # end

  private

  def show(style, text)
    self.visible.value = true
    self.style = style
    self.text.value = text
    self.timeout.value = 100

    Thread.new do
      begin
        sleep 0.075 # TODO: configurable?
        self.timeout.value = self.timeout.value - 1
      end until self.timeout.value == 0
      self.visible.value = false
    end
  end

end