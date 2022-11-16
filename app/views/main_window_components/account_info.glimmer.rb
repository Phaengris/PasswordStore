def render_account_info
  view.children.each(&:destroy)
  view.content {

  }
end

on('AccountsListSelect') { |event|
  account_info.account_path = event.detail
  render_account_info
  break false
}

render_account_info