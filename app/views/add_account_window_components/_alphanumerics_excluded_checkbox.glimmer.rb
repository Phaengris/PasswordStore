rows.with_next { |row|
  checkbutton {
    grid row: row, column: 0, sticky: 'e', padx: [0, 5]
    enabled <= [add_account_window, :password_generated]
    variable <=> [add_account_window, :generated_password_alphanumerics_excluded]
  }
  label {
    grid row: row, column: 1
    text 'Do not use non-alphanumeric symbols'
    enabled <= [add_account_window, :password_generated]
  }
}
