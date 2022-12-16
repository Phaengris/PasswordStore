rows.with_next { |row|
  label {
    grid row: row, column: 0, sticky: 'e', padx: [0, 5], pady: [0, 5]
    # font 'small_caption'
    text 'Length'
    # TODO: implement `disabled` property?
    state <= [add_account_window, :generate_password_state]
  }
  spinbox {
    grid row: row, column: 1, sticky: 'w', pady: [0, 5]
    from 1
    to 128
    text <=> [add_account_window, :generated_password_length]
    width 3
    state <= [add_account_window, :generate_password_state]
  }
}
