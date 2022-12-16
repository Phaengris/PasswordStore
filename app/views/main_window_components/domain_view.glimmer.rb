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
    text <= [domain_view, :name, computed_by: :domain_path]
  }
  button {
    grid row: 0, column: 1, row_span: 2, row_weight: 0, sticky: 'ne'
    width 0
    image Framework.path('app/assets/fontawesome/png/pen-to-square.png').to_s
  }
}

frame {
  grid row: rows.next, row_weight: 1
  padding 0, 5, 0, 0
  button {
    grid row: 0, sticky: 'se', row_weight: 1
    image Framework.path('app/assets/fontawesome/png/trash-can.png').to_s
  }
}

widget.on_redirected_event('AccountsListSelect') { |event|
  # puts "domain_view AccountsListSelect #{event.detail}"
  domain_view.domain_path = event.detail
}

