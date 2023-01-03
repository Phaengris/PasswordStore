rows.with_next { |row|
  checkbutton {
    grid row: row, column: 0, sticky: 'e', padx: [0, 5]
    enabled <= [account_form, :password_generated]
    variable <=> [account_form, :password_no_symbols]
  }
  label {
    grid row: row, column: 1
    text 'Simple password (only letters and numbers)'
    enabled <= [account_form, :password_generated]
  }
}
