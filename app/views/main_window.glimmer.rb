title "Passwords of #{Account.password_store.gpg_id}"
iconphoto Glimte.asset_path('fontawesome/appicon.png').to_s
width 1024
height 1024 / 1.618 # why not? :)
centered true

@flash = Views.shared_components.flash_message {
  grid row: rows.next, row_weight: 0
}

@toolbar = Views.main_window_components.toolbar {
  grid row: rows.next, row_weight: 0
  padding 5
}

frame {
  grid row: rows.next, row_weight: 1
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

on 'FlashSuccessRequest',
   'FlashInfoRequest',
   'FlashAlertRequest',
   'FlashExceptionAlertRequest',
   redirect_to: @flash

on 'AccountsListReloadRequest',
   'SearchEntryKeyUp',
   'SearchEntryKeyDown',
   'SearchStringChange',
   redirect_to: @accounts_list

on('AccountsListSelect') do
  @toolbar.raise_event 'SearchStringFocusRequest'
end
on 'AccountsListSelect', redirect_to: -> (_) { if @accounts_list.view_model.selection_is_account?
                                                 @account_view
                                               else
                                                 @domain_view
                                               end }
# TODO: it breaks the DeleteAccount entry focus. Better way to keep focus on the search entry?
# on('FocusIn') { @toolbar.raise_event('SearchStringFocusRequest') }

on('AddAccountWindowRequest') do
  Views.add_account_window
end

on('KeyPress') do |event|
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
  when ['delete', 0]
    if @domain_view.visible?
      @domain_view.raise_event('DeleteDomainRequest')
    else
      @account_view.raise_event('DeleteAccountRequest')
    end

  when ['q', 4]
    Glimte.exit
  end
end
