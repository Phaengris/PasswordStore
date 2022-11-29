x 200 + 1024
y 200 + 0
width 800
height 600

@toolbar = Views.main_window_components.toolbar {
  grid row: 0, row_weight: 0
}
frame {
  grid row: 1, row_weight: 1
  padding 0
  @account_list = Views.main_window_components.accounts_list {
    grid row: 0, column: 0, row_weight: 1, column_weight: 1, column_uniform: 'accounts_list_and_info'
    width 0
    padding 15, 0, 7, 15
  }
  @account_info = Views.main_window_components.account_info {
    width 0
    grid row: 0, column: 1, row_weight: 0, column_weight: 1, column_uniform: 'accounts_list_and_info'
    padding 7, 0, 15, 15
  }
}

widget.redirect_event 'SearchEntryKeyUp', to: @account_list
widget.redirect_event 'SearchEntryKeyDown', to: @account_list
widget.redirect_event 'SearchStringChange', to: @account_list
widget.redirect_event 'AccountsListSelect', to: @account_info

on('SettingsWindowCall') { Views.settings_window }
on('NewAccountWindowCall') { Views.new_account_window }

on('KeyPress') { |event| case [event.keysym.downcase, event.state]
                         when ['c', 4], ['insert', 4]
                           @account_info.raise_event('CopyPasswordRequest')
                         when ['b', 4]
                           @account_info.raise_event('CopyAccountNameRequest')
                         when ['n', 4]
                           Views.new_account_window
                         when ['e', 4]
                           # edit account
                         when ['d', 4]
                           # delete account
                         when ['q', 4]
                           Framework.exit
                         end }
