rows.with_next { |row|
  label {
    grid row: row, column: 0, sticky: 'e', padx: [0, 5]
    font :caption
    disabled <= [add_account_window, :password_generated]
    text 'Confirm password'
    hidden <= [add_account_window, :password_visible]
  }
  entry {
    grid row: row, column: 1
    text <=> [add_account_window, :password_confirmation]
    show '*'
    disabled <= [add_account_window, :password_generated]
    hidden <= [add_account_window, :password_visible]
  }
}

# label {
#   grid row: rows.next, column: 1
#   style 'Alert.TLabel'
#   visible <= [add_account_window.errors, :password_confirmation]
#   text <= [add_account_window.errors, :password_confirmation]
# }
