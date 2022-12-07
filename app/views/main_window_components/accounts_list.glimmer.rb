@list = treeview {
  grid row_weight: 1
  selectmode :browse
  selection <=> [accounts_list, :selected_account, computed_by: :search_string]
  expanded <= [accounts_list, :all_accounts_shown]
  on('TreeviewSelect') { |event|
    puts "Selected #{accounts_list.selected_account.pretty_inspect}"
  }
}

widget.on_redirected_event('SearchEntryKeyUp')   { |_| accounts_list.select_prev }
widget.on_redirected_event('SearchEntryKeyDown') { |_| accounts_list.select_next }
widget.on_redirected_event('SearchStringChange') { |event| accounts_list.search_string = event.detail.to_s }
