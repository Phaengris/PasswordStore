class ViewModels::MainWindowComponents::AccountView
  attr_accessor :account_path
  attr_accessor :copy_password_to_clipboard_message

  attr_internal_accessor :account

  alias_method :account_path_attr=, :account_path=
  def account_path=(path)
    self.account = Account.find(path)
    self.account = nil unless self.account.entity?
    self.account_path_attr = path
  end

  delegate :name,
           :collection,
           :copy_password_to_clipboard,
           to: :account,
           allow_nil: true
end
