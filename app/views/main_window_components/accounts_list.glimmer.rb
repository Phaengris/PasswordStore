@list = treeview {
  grid row_weight: 1
  selectmode :browse
  selection <=> [accounts_list, :selection, computed_by: :search_string]
  expanded <= [accounts_list, :search_string]
  on('TreeviewSelect') { |event|
    # puts "accounts_list TreeviewSelect #{accounts_list.selection.pretty_inspect}"
    widget.raise_event('AccountsListSelect', accounts_list.selection_path)
  }
}

# widget.on_redirected_event('SearchEntryKeyUp')   { |_| accounts_list.select_prev }
# widget.on_redirected_event('SearchEntryKeyDown') { |_| accounts_list.select_next }
widget.on_redirected_event('SearchStringChange') { |event| accounts_list.search_string = event.detail.to_s }
