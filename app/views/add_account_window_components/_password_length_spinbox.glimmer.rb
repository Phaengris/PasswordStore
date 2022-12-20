rows.with_next { |row|
  label {
    grid row: row, column: 0, sticky: 'e', padx: [0, 5], pady: [0, 5]
    text 'Length'
    enabled <= [add_account_window, :password_generated]
  }
  spinbox {
    grid row: row, column: 1, sticky: 'w', pady: [0, 5]
    from 1
    to 128
    text <=> [add_account_window, :generated_password_length]
    width 3
    enabled <= [add_account_window, :password_generated]
  }
}
