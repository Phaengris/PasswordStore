columns = Sequence.new

@search = entry {
  grid row: 0, column: columns.next, row_weight: 1
  focus true
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

widget.on_redirected_event('SearchStringFocusRequest') { |event|
  @search.tk.set_focus
}
widget.on_redirected_event('SearchStringClearRequest') { |event|
  if @search.text.blank?
    Framework.exit
  else
    @search.text = ''
  end
}
