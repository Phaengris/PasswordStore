label {
  grid row: 0, column_span: 3
  style 'Alert.TLabel'
  text <= [delete_account,
           :code,
           '<=': -> (code) {
             "Account can't be restored after deletion.\nEnter #{code} to confirm."
           }]
}
entry {
  grid row: 1, column: 0, padx: [0, 5]
  width 4
  text <=> [delete_account, :code_confirmation]
  # TODO: it relies on `code` to be updated every time the widget is shown. A separate `focus` property?
  focus <= [delete_account, :code]
  on('KeyPress') { |event|
    if event.keysym == 'Return' && delete_account.code == delete_account.code_confirmation
      widget.raise_action
    end
  }
}
button {
  grid row: 1, column: 1, padx: [0, 5]
  image Framework.path('app/assets/fontawesome/png/trash-can.png').to_s
  enabled <= [delete_account, :code_confirmation, '<=': -> (code_confirmation) { delete_account.code == code_confirmation }]
  on('command') { widget.raise_action }
}
button {
  grid row: 1, column: 2
  image Framework.path('app/assets/fontawesome/png/xmark.png').to_s
  on('command') { widget.raise_cancel }
}

on('Map') { delete_account.regenerate_code }