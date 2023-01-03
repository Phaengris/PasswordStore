title 'Add account'
modal true
escapable true

@flash = Views.shared_components.flash_message {
  grid row: rows.next
}

Views.account_form { |form|
  grid row: rows.next, row_weight: 1

  on_action do
    begin
      add_account_window.add_account form.view_model

    rescue StandardError => e
      @flash.view_model.exception_alert e

    else
      # TODO: why aren't events passed from toplevel to root?
      Views.MainWindow.raise_event 'FlashSuccessRequest', <<-FLASH.squish.strip
        Account #{form.view_model.account} created
        #{"in #{form.view_model.domain}" if form.view_model.domain.present?}
      FLASH
      Views.MainWindow.raise_event 'AccountsListReloadRequest'
      close_window
    end
  end

  on_cancel do
    close_window
  end
}
