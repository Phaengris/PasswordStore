rows.with_next { |row|
  label {
    grid row: row, column: 0, sticky: 'e', padx: [0, 5]
    font :caption
    disabled <= [account_form, :password_generated]
    text 'Confirm password'
    hidden <= [account_form, :password_visible]
  }
  entry {
    grid row: row, column: 1
    text <=> [account_form, :password_confirmation]
    show '*'
    disabled <= [account_form, :password_generated]
    hidden <= [account_form, :password_visible]
  }
}

label {
  grid row: rows.next, column: 1
  style 'Alert.TLabel'
  visible <= [account_form.errors, :password_confirmation]
  text <= [account_form.errors, :password_confirmation]
}
