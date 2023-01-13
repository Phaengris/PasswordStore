label {
  grid row: 0, column_span: 3
  style 'Alert.TLabel'
  text <= [delete_confirmation,
           :code,
           '<=': -> (code) {
             "#{"#{delete_confirmation.message}\n" if delete_confirmation.message.present?}Enter #{code} to confirm."
           }]
}

entry {
  grid row: 1, column: 0, padx: [0, 5]
  width delete_confirmation.code_length
  text <=> [delete_confirmation, :code_confirmation]
  # TODO: it relies on `code` to be updated every time the widget is shown. A separate `focus` property?
  focus <= [delete_confirmation, :code]
  on('KeyPress') do |event|
    if event.keysym == 'Return' && delete_confirmation.code == delete_confirmation.code_confirmation
      action
    end
  end
}

button {
  grid row: 1, column: 1, padx: [0, 5]
  image Glimte.path('app/assets/fontawesome/buttons/trash-can.png').to_s
  enabled <= [delete_confirmation, :code_confirmation, '<=': -> (code_confirmation) { delete_confirmation.code == code_confirmation }]
  on('command') do
    action
  end
}

button {
  grid row: 1, column: 2
  image Glimte.path('app/assets/fontawesome/buttons/xmark.png').to_s
  on('command') do
    cancel
  end
}

on('Map') do
  delete_confirmation.regenerate_code
end
