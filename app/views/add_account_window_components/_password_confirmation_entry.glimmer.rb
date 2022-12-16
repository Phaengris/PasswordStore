rows.with_next { |row|
  label {
    grid row: row, column: 0, sticky: 'e', padx: [0, 5]
    font :caption
    state <= [add_account_window, :password_entries_state]
    text 'Confirm password'
    visible <= [add_account_window, :password_confirmation_visible]
  }
  entry {
    grid row: row, column: 1
    state <= [add_account_window, :password_entries_state]
    text <=> [add_account_window, :password_confirmation]
    show '*'
    visible <= [add_account_window, :password_confirmation_visible]
  }
}

label {
  grid row: rows.next, column: 1
  style 'Alert.TLabel'
  visible <= [add_account_window.errors, :password_confirmation]
  text <= [add_account_window.errors, :password_confirmation]
}
