rows.with_next { |row|
  checkbutton {
    grid row: row, column: 0, sticky: 'e', padx: [0, 5]
    variable <=> [account_form, :password_visible]
    disabled <= [account_form, :password_generated]
  }
  label {
    grid row: row, column: 1, sticky: 'w'
    text 'Show password?'
    disabled <= [account_form, :password_generated]
  }
}
