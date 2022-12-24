visible <= [flash_message, :text]
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
  text <= [flash_message, :text]
  # TODO: wraplength
}