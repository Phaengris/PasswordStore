root {
  width 800
  height 500
  frame {
    grid row: 0, column: 0, column_span: 2
    # Views.main_window.toolbar
    # Views.main_window__toolbar
    # render('main_window/toolbar')
  }
  frame {
    grid row: 1, column: 0, row_weight: 1
    # Views.main_window.accounts_list
    # Views.main_window__accounts_list
  }
  frame {
    grid row: 1, column: 1, row_weight: 1
    # Views.main_window.account_info
    # Views.main_window__account_info
  }
}
