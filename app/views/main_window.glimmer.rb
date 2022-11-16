width 800
height 600

Views.main_window_components.toolbar {
  grid row: 0, column: 0, column_span: 2, row_weight: 0
}
Views.main_window_components.accounts_list {
  grid row: 1, column: 0, row_weight: 1
}
account_info = Views.main_window_components.account_info {
  grid row: 1, column: 1, row_weight: 0
}

# redirect_event 'AccountsListSelect', to: account_info
