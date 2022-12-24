x 800 + 1024
y 350 + 0
width 800
height 600
# TODO: investigate why `center_within_screen` doesn't work properly
# center_within_screen

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
      grid row: 0, column: 0, row_weight: 1
      padding 0
      visible <= [@accounts_list.view_model, :selection_is_account, '<=': -> (v) { v.nil? ? false : !v }]
    }
    @account_view = Views.main_window_components.account_view {
      grid row: 0, column: 0
      padding 0
      visible <= [@accounts_list.view_model, :selection_is_account, '<=': -> (v) { v.nil? ? false : v }]
    }
  }
}

redirect_event 'SearchEntryKeyUp',   to: @accounts_list
redirect_event 'SearchEntryKeyDown', to: @accounts_list
redirect_event 'SearchStringChange', to: @accounts_list
redirect_event 'AccountsListSelect', to: -> (_) { if @accounts_list.view_model.selection_is_account?
                                                    @account_view
                                                  else
                                                    @domain_view
                                                  end }
# on('AccountsListSelect') { |event|
#   EventProxy.new(event).pass_to if @accounts_list.view_model.selection_is_account
#                                   @account_view
#                                 else
#                                   @domain_view
#                                 end
# }
on('AccountsListSelect') { |event|
  @toolbar.raise_event('SearchStringFocusRequest')
}
on('FocusIn') { |event|
  @toolbar.raise_event('SearchStringFocusRequest')
}
on('AddAccountWindowCall') { Views.add_account_window }
on('AccountAdd') { |event|
  @toolbar.raise_event 'SearchStringClearRequest'
  # @accounts_list.view_model.selection = event.detail
  # @accounts_list.view_model.selection_path = event.detail
  # @accounts_list.view_model.selection = TreeviewUtils.build_branch_from_path(event.detail)
}
on('SettingsWindowCall') { Views.settings_window }

on('KeyPress') { |event|
  # event_proxy = EventProxy.new(event)
  # event_proxy.ctrl? && event_proxy.keysym?('a')
  # event_proxy.keypress?('ctrl a')

  case [event.keysym.downcase, event.state]

  when ['up', 0]
    @accounts_list.raise_event('AccountsListPrevItemRequest')
  when ['down', 0]
    @accounts_list.raise_event('AccountsListNextItemRequest')
  when ['escape', 0]
    @toolbar.raise_event('SearchStringClearRequest')

  when ['c', 4], ['insert', 4]
    @account_view.raise_event('CopyPasswordRequest') if @account_view.visible?
  when ['b', 4]
    @account_view.raise_event('CopyAccountNameRequest') if @account_view.visible?
  when ['d', 4]
    if @domain_view.visible?
      @domain_view.raise_event('CopyDomainNameRequest')
    else
      @account_view.raise_event('CopyDomainNameRequest')
    end

  when ['n', 4]
    Views.add_account_window
  when ['e', 4]
    # edit account
  when ['d', 4]
    # delete account

  when ['q', 4]
    Framework.exit
  end
}
