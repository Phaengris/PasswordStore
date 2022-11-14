Sequence.new { |columns|
  button {
    grid row: 0, column: columns.next, sticky: '', padx: 5
    text 'Add account'
  }
  button {
    grid row: 0, column: columns.next, sticky: '', padx: 5
    text 'Edit account'
  }
  button {
    grid row: 0, column: columns.next, sticky: '', padx: 5
    text 'Delete account'
  }
  separator do
    grid row: 0, column: columns.next, padx: 5
  end
  button do
    grid row: 0, column: columns.next, sticky: '', padx: 5
    text 'Settings'
  end
  frame {
    grid row: 0, column: columns.next, column_weight: 99
  }
}
