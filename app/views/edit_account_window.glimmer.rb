title <<-TITLE
  Edit account #{edit_account_window.name}
  #{"in #{edit_account_window.collection_path}" if edit_account_window.collection_path.present?}
TITLE
modal true
escapable true

@flash = Views.shared_components.flash_message {
  grid row: rows.next
}

Views.account_form { |form|
  grid row: rows.next, row_weight: 1
  account_path edit_account_window.account_path

  on_action do
    begin
      edit_account_window.update_account form.view_model

    rescue StandardError => e
      @flash.view_model.exception_alert e

    else
      Views.MainWindow.raise_event 'FlashSuccessRequest', <<-FLASH.squish.strip
        Updated account #{form.view_model.account}
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

