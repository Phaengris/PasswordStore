rows.with_next { |row|
  checkbutton {
    grid row: row, column: 0, sticky: 'e', padx: [0, 5], pady: [0, 5]
    variable <=> [add_account_window, :password_generated]
  }
  label {
    grid row: row, column: 1, sticky: 'w', pady: [0, 5]
    font :caption
    text 'Generate password?'
  }
}
