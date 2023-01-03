@search = entry {
  grid row: 0, column: columns.next, row_weight: 1
  focus true
  on('Change') do |value|
    raise_event('SearchStringChange', value.to_s)
  end
}

button {
  grid row: 0, column: columns.next, padx: [5, 0]
  width 0
  image Framework.path('app/assets/fontawesome/buttons/square-plus.png').to_s
  on('command') do
    raise_event('AddAccountWindowRequest')
  end
}

button {
  grid row: 0, column: columns.next, padx: [5, 0]
  width 0
  image Framework.path('app/assets/fontawesome/buttons/rotate.png').to_s
  on('command') do
    #
  end
  disabled true
}

button {
  grid row: 0, column: columns.next, padx: [5, 0]
  image Framework.path('app/assets/fontawesome/buttons/bars.png').to_s
  width 0
  compound :center
  on('command') do
    #
  end
  disabled true
}

on('SearchStringFocusRequest', redirected: true) do
  @search.tk.set_focus
end

on('SearchStringClearRequest', redirected: true) do
  if @search.text.blank?
    Framework.exit
  else
    @search.text = ''
    raise_event('SearchStringChange', '')
  end
end
