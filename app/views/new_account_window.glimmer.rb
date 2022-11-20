title 'New account'

widget.center_within_root
widget.modal
escapable true

frame {
  grid row_weight: 1
  rows = Sequence.new

  rows.with_next { |row|
    label {
      grid row: row, column: 0, column_weight: 0, sticky: 'e', column_uniform: 'u', pady: [0, 15], padx: [0, 5]
      font :caption
      text 'Account'
    }
    entry {
      grid row: row, column: 1, column_weight: 1, sticky: 'nsew', column_uniform: 'u', pady: [0, 15]
      focus true
    }
  }

  rows.with_next { |row|
    checkbutton {
      grid row: row, column: 0, sticky: 'e', pady: [0, 15], padx: [0, 5]
    }
    label {
      grid row: row, column: 1, sticky: 'w', pady: [0, 15]
      font :caption
      text 'Generate password?'
    }
  }

  rows.with_next { |row|
    label {
      grid row: row, column: 0, sticky: 'e', pady: [0, 15], padx: [0, 5]
      font :caption
      text 'Password'
    }
    entry {
      grid row: row, column: 1, sticky: 'nsew', pady: [0, 15]
    }
  }

  rows.with_next { |row|
    label {
      grid row: row, column: 0, sticky: 'e', pady: [0, 15], padx: [0, 5]
      font :caption
      text 'Confirm password'
    }
    entry {
      grid row: row, column: 1, sticky: 'nsew', pady: [0, 15]
    }
  }

  frame {
    grid row: rows.next, row_weight: 1, column_span: 2
    padding 0
    button {
      grid row: 0, column: 0, row_weight: 1, sticky: 'se', padx: [0, 5]
      width 0
      text 'OK'
    }
    # button {
    #   grid row: 0, column: 1, sticky: 'se'
    #   width 0
    #   text 'Cancel'
    # }
  }

}
