entry {
  grid row: 0, column: 0, row_weight: 0
  text <=> [accounts_list, :search_terms]
  focus <=> [accounts_list, :search_entry_focused]
  on('KeyPress') { |event| accounts_list.search_entry_keypress(event) }
}

list {
  grid row: 1, column: 0, row_weight: 1000
  selectmode :browse
  items <= [accounts_list, :selected_account_options, computed_by: :search_terms]
  selection <=> [accounts_list, :selected_account, computed_by: :selected_account_position]
  on('KeyPress') { |event|
    accounts_list.accounts_list_keypress(event)
  }
  on('TreeviewSelect') { |event|
    break if event.widget.selection.empty?

    event.widget.event_generate('<AccountsListSelect>', data: accounts_list.selected_account_path)
  }
}
