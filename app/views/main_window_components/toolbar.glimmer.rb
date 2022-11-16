columns = Sequence.new

button {
  grid row: 0, column: columns.next, sticky: '', padx: 5
  text 'Add account'
}
button {
  grid row: 0, column: columns.next, sticky: '', padx: 5
  text 'Edit account'
}
button {
  grid row: 0, column: columns.next, sticky: '', padx: 5
  text 'Delete account'
}
separator {
  grid row: 0, column: columns.next, padx: 5
}
button {
  grid row: 0, column: columns.next, sticky: '', padx: 5
  text 'Settings'
  on('command') {
    # ... .event_generate('<SettingsWindowCalled>')
  }
}
frame {
  grid row: 0, column: columns.next, column_weight: 99
}
