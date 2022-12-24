rows.with_next { |row|
  label {
    grid row: row, column: 0, sticky: 'e', padx: [0, 5]
    font :caption
    text 'Account'
  }
  entry {
    grid row: row, column: 1
    focus true
    text <=> [add_account_window, :account]
  }
}

label {
  grid row: rows.next, column: 1
  style 'Alert.TLabel'
  visible <= [add_account_window.errors, :account]
  text <= [add_account_window.errors, :account]
}
