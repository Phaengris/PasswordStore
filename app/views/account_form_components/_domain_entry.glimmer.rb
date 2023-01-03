rows.with_next { |row|
  label {
    grid row: row, column: 0, column_weight: 1000, sticky: 'e', column_uniform: 'u', padx: [0, 5]
    font :caption
    text 'Domain'
  }
  entry {
    grid row: row, column: 1, column_weight: 1618, column_uniform: 'u'
    text <=> [account_form, :domain]
  }
}

label {
  grid row: rows.next, column: 1
  visible <= [account_form.errors, :domain]
  style 'Alert.TLabel'
  text <= [account_form.errors, :domain]
}
