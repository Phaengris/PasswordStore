class ViewModels::SharedComponents::FlashMessage

  attr_accessor :style,
                :text

  def alert(text)
    self.style = 'alert'
    self.text = text
  end

end