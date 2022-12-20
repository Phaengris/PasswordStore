rows.with_next { |row|
  label {
    grid row: row, column: 0, sticky: 'e', padx: [0, 5]
    font :caption
    text 'Additional Notes'
  }
  text {
    grid row: row, column: 1
    text <=> [add_account_window, :notes]
  }
}