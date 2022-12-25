@list = treeview {
  grid row_weight: 1
  selectmode :browse
  selection <=> [accounts_list, :selection, computed_by: :search_string]
  expanded <= [accounts_list, :search_string]
  on('TreeviewSelect') { |event|
    widget.raise_event('AccountsListSelect', accounts_list.selection_path)
  }
}

widget.on_redirected_event('AccountsListPrevItemRequest') { |_| @list.select_prev }
widget.on_redirected_event('AccountsListNextItemRequest') { |_| @list.select_next }
widget.on_redirected_event('SearchStringChange') { |event| accounts_list.search_string = event.detail.to_s }
widget.on_redirected_event('AccountsListReloadRequest') { |_| accounts_list.reload }
