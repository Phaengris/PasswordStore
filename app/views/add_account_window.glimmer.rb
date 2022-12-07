title 'Add account'
widget.center_within_root
widget.modal
escapable true

frame {
  grid row: 0, row_weight: 0
  rows = Sequence.new

  rows.with_next { |row|
    label {
      grid row: row, column: 0, column_weight: 0, sticky: 'e', column_uniform: 'u', pady: [0, 15], padx: [0, 5]
      font :caption
      text 'Domain'
    }
    entry {
      grid row: row, column: 1, column_weight: 1, sticky: 'nsew', column_uniform: 'u', pady: [0, 15]
      focus true
    }
  }

  rows.with_next { |row|
    label {
      grid row: row, column: 0, sticky: 'e', pady: [0, 15], padx: [0, 5]
      font :caption
      text 'Account'
    }
    entry {
      grid row: row, column: 1, sticky: 'nsew', pady: [0, 15]
      focus true
    }
  }

  rows.with_next { |row|
    checkbutton {
      grid row: row, column: 0, sticky: 'e', padx: [0, 5], pady: [0, 5]
    }
    label {
      grid row: row, column: 1, sticky: 'w', pady: [0, 5]
      font :caption
      text 'Generate password?'
    }
  }

  rows.with_next { |row|
    label {
      grid row: row, column: 0, sticky: 'e', padx: [0, 5], pady: [0, 5]
      # font 'small_caption'
      text 'Length'
      state 'disabled'
    }
    spinbox {
      grid row: row, column: 1, sticky: 'w', pady: [0, 5]
      from 1
      to 128
      text '16'
      width 3
      state 'disabled'
    }
  }

  rows.with_next { |row|
    checkbutton {
      grid row: row, column: 0, sticky: 'e', padx: [0, 5], pady: [0, 15]
      state 'disabled'
    }
    label {
      grid row: row, column: 1, pady: [0, 15]
      text 'Do not use non-alphanumeric symbols'
      state 'disabled'
    }
  }

  @password_components = []

  rows.with_next { |row|
    @password_components << label {
      grid row: row, column: 0, sticky: 'e', pady: [0, 15], padx: [0, 5]
      font :caption
      text 'Password'
    }
    @password_components << entry {
      grid row: row, column: 1, sticky: 'nsew', pady: [0, 15]
    }
  }

  rows.with_next { |row|
    @password_components << label {
      grid row: row, column: 0, sticky: 'e', pady: [0, 15], padx: [0, 5]
      font :caption
      text 'Confirm password'
    }
    @password_components << entry {
      grid row: row, column: 1, sticky: 'nsew', pady: [0, 15]
    }
  }
}
frame {
  grid row: 1, row_weight: 1
  button {
    grid row: 0, column: 0, row_weight: 1, sticky: 'se', padx: [0, 5]
    text 'OK'
  }
  button {
    grid row: 0, column: 1, sticky: 'se'
    text 'Cancel'
    on('command') {
      widget.grab_release
      widget.destroy
    }
  }
}
