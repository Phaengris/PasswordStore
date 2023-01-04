padding 0

frame {
  grid row: rows.next, row_weight: 1

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
  password_no_symbols_checkbox
  rows_separator

  password_entry
  password_visible_checkbox
  password_confirmation_entry
  # }
}

Views.shared_components.ok_cancel_buttons {
  grid row: rows.next, row_weight: 0
  on_action do
    action if account_form.valid?
  end
  on_cancel do
    cancel
  end
}

on('KeyPress') do |event|
  case
  when event.keysym == 'Return' && event.state == 0
    action if account_form.valid?
  when event.keysym == 'Escape' && event.state == 0
    cancel
  end
end
