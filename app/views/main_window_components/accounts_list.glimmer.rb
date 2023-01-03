@list = treeview {
  grid row_weight: 1
  selectmode :browse
  show :tree
  selection <=> [accounts_list, :selection, computed_by: :search_string]
  expanded <= [accounts_list, :search_string]
  on('TreeviewSelect') do
    raise_event('AccountsListSelect', accounts_list.selection_path)
  end
}

on('AccountsListPrevItemRequest', redirected: true) do
  @list.select_prev
end
on('AccountsListNextItemRequest', redirected: true) do
  @list.select_next
end
on('SearchStringChange', redirected: true) do |event|
  accounts_list.search_string = event.detail.to_s
end
on('AccountsListReloadRequest', redirected: true) do
  accounts_list.reload
end
