require 'clipboard'

class ViewModels::MainWindowComponents::AccountInfo
  attr_accessor :account_path
  attr_accessor :copy_password_to_clipboard_message

  attr_internal_accessor :account

  def account_path=(path)
    @account_path = path
    self.account = Account.select(path).first
  end

  delegate :name, :dir, :copy_password_to_clipboard,
           to: :account, allow_nil: true

end
