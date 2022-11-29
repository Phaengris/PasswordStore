@list = list {
  grid row_weight: 1
  selectmode :browse
  # items <= [accounts_list, :selected_account_options, computed_by: :search_string]
  # selection <=> [accounts_list, :selected_account, computed_by: :selected_account_position]
  on('TreeviewSelect') { |event|
    # break if event.widget.selection.empty?
    #
    # widget.raise_event('AccountsListSelect', accounts_list.selected_account_path)
    pp @list.tk.selection.to_s
  }
}

widget.on_redirected_event('SearchEntryKeyUp')   { |_| accounts_list.select_prev }
widget.on_redirected_event('SearchEntryKeyDown') { |_| accounts_list.select_next }
widget.on_redirected_event('SearchStringChange') { |event| accounts_list.search_string = event.detail.to_s }

@list.tk.insert('', 'end', id: :'somesite.com', text: 'SomeSite.com')
@list.tk.insert('somesite.com', 'end', text: 'SomeAccount')