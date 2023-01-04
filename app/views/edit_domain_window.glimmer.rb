title <<-TITLE
  Edit domain #{edit_domain_window.domain_path}
TITLE
# TODO: modal = true seems to ignore width / height :(
width 600
height 600 / 1.618
modal true
escapable true

@flash = Views.shared_components.flash_message {
  grid row: rows.next
}

frame {
  grid row: rows.next

  label {
    grid row: 0, column: 0, column_weight: 1000, sticky: 'e', column_uniform: 'u', padx: [0, 5]
    font :caption
    text 'Domain'
  }
  entry {
    grid row: 0, column: 1, column_weight: 1618, column_uniform: 'u'
    focus true
    text <=> [edit_domain_window, :domain_path]
  }

  label {
    grid row: 1, column: 1
    visible <= [edit_domain_window.errors, :domain_path]
    style 'Alert.TLabel'
    text <= [edit_domain_window.errors, :domain_path]
  }
}

Views.shared_components.ok_cancel_buttons {
  grid row: rows.next, row_weight: 1

  on_action do
    action
  end

  on_cancel do
    cancel
  end
}

on('KeyPress') do |event|
  case
  when event.keysym == 'Return' && event.state == 0
    action if edit_domain_window.valid?
  when event.keysym == 'Escape' && event.state == 0
    cancel
  end
end

on_action do
  next unless edit_domain_window.valid?

  begin
    edit_domain_window.update_domain

  rescue StandardError => e
    @flash.view_model.exception_alert e

  else
    Views.MainWindow.raise_event 'FlashSuccessRequest', <<-FLASH.squish.strip
      Updated domain #{edit_domain_window.domain_path}
    FLASH
    Views.MainWindow.raise_event 'AccountsListReloadRequest'
    close_window
  end
end

on_cancel do
  close_window
end
