x 800 + 1024
y 350 + 0
width 800
height 600
# TODO: investigate why `center_within_screen` doesn't work properly
# center_within_screen
escapable true

@toolbar = Views.main_window_components.toolbar {
  grid row: 0, row_weight: 0
  padding 5
}
frame {
  grid row: 1, row_weight: 1
  padding 0
  @accounts_list = Views.main_window_components.accounts_list {
    grid row: 0, column: 0, row_weight: 1, column_weight: 1, column_uniform: 'accounts_list_and_view'
    width 0
    padding 5, 0, 5, 5
  }

  frame {
    grid row: 0, column: 1, row_weight: 0, column_weight: 1, column_uniform: 'accounts_list_and_view'
    width 0
    padding 20, 20, 5, 5
    @domain_view = Views.main_window_components.domain_view {
      padding 0
      # visible <= [@accounts_list.view_model, :selection_is_domain?]
    }
    @account_view = Views.main_window_components.account_view {
      padding 0
      # visible <= [@accounts_list.view_model, :selection_is_account?]
    }
  }
}

@account_view.grid_remove
@domain_view.grid_remove

# redirect_event 'SearchEntryKeyUp', to: @accounts_list
# redirect_event 'SearchEntryKeyDown', to: @accounts_list
redirect_event 'SearchStringChange', to: @accounts_list
on('AccountsListSelect') { |event|
  # TODO: implement `visible` property (how to manage row / column weights?)
  # TODO: or send "selection_is_account? / selection_is_domain?" inside the event's data?
  case
  when @accounts_list.view_model.selection_is_account?
    @account_view.grid row_weight: 1
    @domain_view.grid row_weight: 0
    @domain_view.grid_remove

    # @account_view.raise_event('AccountsListSelect', event.detail)
    @account_view.raise_event('AccountsListSelect', @accounts_list.view_model.selection_path)

  when @accounts_list.view_model.selection_is_domain?
    @account_view.grid row_weight: 0
    @account_view.grid_remove
    @domain_view.grid row_weight: 1

    # @domain_view.raise_event('AccountsListSelect', event.detail)
    @domain_view.raise_event('AccountsListSelect', @accounts_list.view_model.selection_path)
  end
}
# redirect_event 'AccountsListSelect', to: -> (event) {
#   @accounts_list.view_model.selection_is_account? ? @accounts_view : @domain_view
# }

on('SettingsWindowCall') { Views.settings_window }
on('AddAccountWindowCall') { Views.add_account_window }

on('KeyPress') { |event| case [event.keysym.downcase, event.state]
                         when ['c', 4], ['insert', 4]
                           @account_view.raise_event('CopyPasswordRequest')
                         when ['b', 4]
                           @account_view.raise_event('CopyAccountNameRequest')
                         when ['n', 4]
                           Views.add_account_window
                         when ['e', 4]
                           # edit account
                         when ['d', 4]
                           # delete account
                         when ['q', 4]
                           Framework.exit
                         end }
