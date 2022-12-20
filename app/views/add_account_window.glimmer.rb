title 'Add account'
widget.modal
escapable true

frame {
  grid row: 0, row_weight: 1
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

Views.shared_components.ok_cancel_buttons {
  grid row: 1, row_weight: 0
}

on('KeyPress') { |event|
  case event.keysym
  when 'Return' then widget.raise_event('Action')
  end
}

on('Action') { |event|
  add_account_window.action
}
