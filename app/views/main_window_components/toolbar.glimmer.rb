columns = Sequence.new

@search = entry {
  grid row: 0, column: columns.next, row_weight: 1, padx: [0, 5], sticky: 'ew'
  focus true
  on('KeyPress') { |event| case event.keysym
                           when 'Escape' then @search.text = ''
                           when 'Up', 'Down' then widget.raise_event("SearchEntryKey#{event.keysym}")
                           end }
  on('Change') { |value| widget.raise_event('SearchStringChange', value.to_s) }
}
button {
  grid row: 0, column: columns.next, sticky: 'ne'
  width 0
  text 'Add'
  on('command') { widget.raise_event('AddAccountWindowCall') }
}
button {
  grid row: 0, column: columns.next, sticky: 'ne', padx: [15, 0]
  width 0
  text 'Set'
  on('command') { widget.raise_event('SettingsWindowCall') }
}
