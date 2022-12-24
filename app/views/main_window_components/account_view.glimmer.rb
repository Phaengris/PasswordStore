rows = Sequence.new

frame {
  grid row: rows.next
  padding 0, 0, 0, 15
  label {
    grid row: 0, column: 0, column_weight: 1, sticky: 'nw'
    font 'caption'
    text 'Domain'
  }
  label {
    grid row: 1, column: 0, sticky: 'nw'
    text <= [account_view, :collection_name, computed_by: :account_path]
  }
  button {
    grid row: 0, column: 1, row_span: 2, row_weight: 0, sticky: 'ne'
    width 0
    image Framework.path('app/assets/fontawesome/png/copy.png').to_s
  }
}

frame {
  grid row: rows.next
  padding 0, 0, 0, 15
  label {
    grid row: 0, column: 0, column_weight: 1, sticky: 'nw'
    font 'caption'
    text 'Account'
  }
  label {
    grid row: 1, column: 0, sticky: 'nw'
    text <= [account_view, :entity_name, computed_by: :account_path]
  }
  button {
    grid row: 0, column: 1, row_span: 2, row_weight: 0, sticky: 'ne'
    width 0
    image Framework.path('app/assets/fontawesome/png/copy.png').to_s
  }
}

frame {
  grid row: rows.next
  padding 0, 0, 0, 15
  label {
    grid row: 0, column: 0, column_weight: 1, sticky: 'nw'
    font 'caption'
    text 'Password'
  }
  label {
    grid row: 1, column: 0, sticky: 'nw'
    text '******'
  }
  button {
    grid row: 0, column: 1, row_span: 2, row_weight: 0, sticky: 'ne'
    width 0
    image Framework.path('app/assets/fontawesome/png/copy.png').to_s
  }
}

frame {
  grid row: rows.next, row_weight: 1
  padding 0, 5, 0, 0
  button {
    grid row: 0, row_weight: 1, sticky: 'ne', pady: [0, 15]
    image Framework.path('app/assets/fontawesome/png/pen-to-square.png').to_s
  }
  button {
    grid row: 1, sticky: 'se'
    image Framework.path('app/assets/fontawesome/png/trash-can.png').to_s
  }
}

# TODO: implement OnRedirectedEventExpression?
widget.on_redirected_event('AccountsListSelect') { |event|
  account_view.account_path = event.detail
}
on('CopyPasswordRequest')    { account_view.copy_password_to_clipboard }
on('CopyAccountNameRequest') { account_view.copy_account_name_to_clipboard }
on('CopyDomainNameRequest')  { account_view.copy_domain_name_to_clipboard }