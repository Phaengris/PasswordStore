columns = Sequence.new

@search = entry {
  grid row: 0, column: columns.next, row_weight: 1
  focus true
  on('KeyPress') { |event| case event.keysym
                           when 'Escape' then @search.text = ''
                           when 'Up', 'Down' then widget.raise_event("SearchEntryKey#{event.keysym}")
                           end }
  # TODO: implement also RaiseEventExpression?
  on('Change') { |value| widget.raise_event('SearchStringChange', value.to_s) }
}
button {
  grid row: 0, column: columns.next, padx: [5, 0]
  width 0
  image Framework.path('app/assets/fontawesome/png/square-plus.png').to_s
  on('command') { widget.raise_event('AddAccountWindowCall') }
}
button {
  grid row: 0, column: columns.next, padx: [5, 0]
  width 0
  image Framework.path('app/assets/fontawesome/png/rotate.png').to_s
  on('command') { widget.raise_event('GitReloadStoreCall') }
}
button {
  grid row: 0, column: columns.next, padx: [5, 0]
  image Framework.path('app/assets/fontawesome/png/bars.png').to_s
  width 0
  compound :center
  on('command') { widget.raise_event('DoSomething') }
}
