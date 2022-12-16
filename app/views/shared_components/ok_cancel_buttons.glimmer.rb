grid row_weight: 1
frame { grid row: 0, pady: [0, 15] }
button {
  grid row: 1, column: 0, row_weight: 1, sticky: 'se', padx: [0, 5]
  style 'Accent.TButton'
  text 'OK'
  on('command') {
    widget.raise_event('Action')
  }
}
button {
  grid row: 1, column: 1, sticky: 'se'
  text 'Cancel'
  on('command') {
    widget.raise_event('Cancel')
  }
}
