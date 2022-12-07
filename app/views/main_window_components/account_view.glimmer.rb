frame {
  grid row_weight: 1
  # flat, groove, raised, ridge, solid, or sunken
  relief 'solid' # for Azure theme
  # relief 'groove' # for default Tk theme

  frame {
    grid row: 0, pady: [0, 15]
    padding 0
    label {
      grid row: 0, column: 0, column_weight: 1, sticky: 'nw'
      font 'caption'
      text 'Domain'
    }
    label {
      grid row: 1, column: 0, sticky: 'nw'
      text <= [account_view, :dir, computed_by: :account_path]
    }
    button {
      grid row: 0, column: 1, row_span: 2, row_weight: 0, sticky: 'ne'
      width 0
      text 'Cpy'
    }
  }

  frame {
    grid row: 1, pady: [0, 15]
    padding 0
    label {
      grid row: 0, column: 0, column_weight: 1, sticky: 'nw'
      font 'caption'
      text 'Account'
    }
    label {
      grid row: 1, column: 0, sticky: 'nw'
      text <= [account_view, :name, computed_by: :account_path]
    }
    button {
      grid row: 0, column: 1, row_span: 2, row_weight: 0, sticky: 'ne'
      width 0
      text 'Cpy'
    }
  }

  frame {
    grid row: 2, sticky: 'ew', pady: [0, 15]
    padding 0
    button {
      grid row: 0, sticky: 'ne', pady: [0, 15]
      text 'Cpy pass'
      on('command') { account_view.copy_password_to_clipboard }
    }
    label {
      grid row: 1, sticky: 'ne'
      text <= [account_view, :copy_password_to_clipboard_message]
    }
  }

  frame {
    grid row: 3, row_weight: 1
    padding 0
    button {
      grid row: 0, row_weight: 1, sticky: 'se', pady: [0, 15]
      text 'Edit'
    }
    button {
      grid row: 1, sticky: 'se'
      text 'Delete'
    }
  }
}

widget.on_redirected_event('AccountsListSelect') { |event|
  account_view.account_path = event.detail
}
on('CopyPasswordRequest') { account_view.copy_password_to_clipboard }
on('CopyAccountNameRequest') { account_view.copy_name_to_clipboard }