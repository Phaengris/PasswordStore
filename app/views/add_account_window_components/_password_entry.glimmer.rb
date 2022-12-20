rows.with_next { |row|
  label {
    grid row: row, column: 0, sticky: 'e', padx: [0, 5]
    font :caption
    text 'Password'
    disabled <= [add_account_window, :password_generated]
  }
  entry {
    grid row: row, column: 1
    disabled <= [add_account_window, :password_generated]
    text <=> [add_account_window, :password]
    show <= [add_account_window, :password_visible, '<=': -> (visible) { visible ? '' : '*'}]
  }
}

# label {
#   grid row: rows.next, column: 1
#   style 'Alert.TLabel'
#   visible <= [add_account_window.errors, :password]
#   text <= [add_account_window.errors, :password]
# }
