entry {
  grid row: 0, column: 0
  # text <=> [accounts_list, :search_terms]
  # focus <=> [accounts_list, :search_entry_focused]
  # on('KeyPress') { |event| accounts_list.search_entry_keypress(event) }
}
list {
  grid row: 1, column: 0, row_weight: 1
  selectmode :browse
  # items <= [accounts_list, :selected_account_options, computed_by: :search_terms]
  # selection <=> [accounts_list, :selected_account, computed_by: :selected_account_position]
  # on('KeyPress') { |event| accounts_list.accounts_list_keypress(event) }
}
