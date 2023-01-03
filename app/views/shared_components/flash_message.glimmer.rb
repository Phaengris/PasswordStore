padding 0
visible <= [flash_message.visible, :value]
style <= [flash_message, :style, '<=': -> (style) { if style
                                                      "Flash#{style.capitalize}.TFrame"
                                                    else
                                                      'TFrame'
                                                    end } ]

frame {
  grid row: 0, sticky: 'nse'
  style <= [flash_message, :style, '<=': -> (style) { if style
                                                        "Flash#{style.capitalize}Timeout.TFrame"
                                                      else
                                                        'TFrame'
                                                      end } ]
  height 5
  padding 0
  width <= [flash_message.timeout, :value, '<=': -> (v) { (widget.tk.winfo_width * v / 100).floor }]
}

frame {
  grid row: 1
  style <= [flash_message, :style, '<=': -> (style) { if style
                                                        "Flash#{style.capitalize}.TFrame"
                                                      else
                                                        'TFrame'
                                                      end } ]
  label {
    grid sticky: ''
    style <= [flash_message, :style, '<=': -> (style) { if style
                                                          "Flash#{style.capitalize}.TLabel"
                                                        else
                                                          'TLabel'
                                                        end } ]
    text <= [flash_message.text, :value]
    # TODO: wraplength
  }
}

on('FlashSuccessRequest', redirected: true) do |event|
  flash_message.success event.detail
end
on('FlashInfoRequest', redirected: true) do |event|
  flash_message.info event.detail
end
on('FlashAlertRequest', redirected: true) do |event|
  flash_message.alert event.detail
end
on('FlashExceptionAlertRequest', redirected: true) do |event|
  # TODO: move exception load with some safety measures into the view model?
  flash_message.alert YAML.unsafe_load(event.detail)
end
