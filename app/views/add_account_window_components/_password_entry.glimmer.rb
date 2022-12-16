rows.with_next { |row|
  label {
    grid row: row, column: 0, sticky: 'e', padx: [0, 5]
    font :caption
    text 'Password'
    state <= [add_account_window, :password_entries_state]
    focus <=> [add_account_window, :password_focus]
  }
  entry {
    grid row: row, column: 1
    state <= [add_account_window, :password_entries_state]
    text <=> [add_account_window, :password]
    show <= [add_account_window, :password_hide_char]
  }
}

label {
  grid row: rows.next, column: 1
  style 'Alert.TLabel'
  visible <= [add_account_window.errors, :password]
  text <= [add_account_window.errors, :password]
}
