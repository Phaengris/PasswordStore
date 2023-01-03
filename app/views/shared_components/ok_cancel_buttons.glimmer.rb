rows_separator

rows.with_next do |row|
  button {
    grid row: row, column: 0, row_weight: 1, sticky: 'se', padx: [0, 5]
    style 'Accent.TButton'
    text 'OK'
    on('command') do
      action
    end
  }

  button {
    grid row: row, column: 1, sticky: 'se'
    text 'Cancel'
    on('command') do
      cancel
    end
  }
end
