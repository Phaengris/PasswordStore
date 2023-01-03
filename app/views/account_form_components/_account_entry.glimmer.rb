rows.with_next { |row|
  label {
    grid row: row, column: 0, sticky: 'e', padx: [0, 5]
    font :caption
    text 'Account'
  }
  entry {
    grid row: row, column: 1
    focus true
    text <=> [account_form, :account]
  }
}

label {
  grid row: rows.next, column: 1
  style 'Alert.TLabel'
  visible <= [account_form.errors, :account]
  text <= [account_form.errors, :account]
}
