title 'Add account'
widget.modal
escapable true

frame {
  grid row: 0, row_weight: 0

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
}

Views.shared_components.ok_cancel_buttons {
  grid row: 1
}

on('KeyPress') { |event|
  case event.keysym
  when 'Return' then widget.raise_event('Action')
  end
}

on('Action') { |event|
  add_account_window.validate
}
