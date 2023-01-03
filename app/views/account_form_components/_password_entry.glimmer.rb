rows.with_next { |row|
  label {
    grid row: row, column: 0, sticky: 'e', padx: [0, 5]
    font :caption
    text 'Password'
    disabled <= [account_form, :password_generated]
  }
  entry {
    grid row: row, column: 1
    disabled <= [account_form, :password_generated]
    text <=> [account_form, :password]
    show <= [account_form, :password_visible, '<=': -> (visible) { visible ? '' : '*'}]
  }
}

label {
  grid row: rows.next, column: 1
  style 'Alert.TLabel'
  visible <= [account_form.errors, :password]
  text <= [account_form.errors, :password]
}
