rows.with_next { |row|
  checkbutton {
    grid row: row, column: 0, sticky: 'e', padx: [0, 5]
    variable <=> [add_account_window, :password_visible]
    state <= [add_account_window, :password_entries_state]
  }
  label {
    grid row: row, column: 1, sticky: 'w'
    text 'Show password?'
  }
}
