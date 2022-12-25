title 'Add account'
widget.modal
escapable true

@flash = Views.shared_components.flash_message {
  grid row: 0
}

frame {
  grid row: 1, row_weight: 1
  # TODO: scrolled frame doesn't adapt to it's parent width due to Tk specifics. Can we do something with it?
  # TODO: also it doesn't respond to scroll mouse events on the frame itself, only on the scrollbars
  # scrollbar_frame {
  #   xscrollbar false
    domain_entry
    rows_separator

    account_entry
    rows_separator

    password_generated_checkbox
    password_length_spinbox
    alphanumerics_excluded_checkbox
    rows_separator

    password_entry
    password_visible_checkbox
    password_confirmation_entry
  # }
}

@ok_cancel_buttons = Views.shared_components.ok_cancel_buttons {
  grid row: 2, row_weight: 0
}
# TODO: find a better way to pass private events
@ok_cancel_buttons.on_action { widget.raise_action }
@ok_cancel_buttons.on_cancel { widget.raise_cancel }

on('KeyPress') { |event|
  case event.keysym
  when 'Return' then widget.raise_action
  # when 'Escape' then widget.raise_cancel
  end
}

widget.on_action {
  begin
    add_account_window.action
  rescue StandardError => e
    @flash.view_model.alert "Sorry, failed to add account. Application reports:\n#{e.class}: #{e}"
  else
    break if add_account_window.errors.any?
    # TODO: should we wipe password / password_confirmation entry values?
    Views.MainWindow.raise_event 'AccountsListReloadRequest'
    widget.destroy
  end
}
widget.on_cancel {
  widget.destroy
}