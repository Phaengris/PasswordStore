require 'clipboard'

class ViewModels::MainWindowComponents::AccountView
  attr_accessor :account_path,
                :want_delete

  attr_internal_accessor :account

  on_attr_write(:account_path) do |value|
    self.account = Account.where(value).only(:entities).first if value.present?
  end

  delegate :entity_name,
           :collection_name,
           to: :account,
           allow_nil: true

  def copy_domain_name_to_clipboard
    Clipboard.copy account.collection_name
  end

  def copy_account_name_to_clipboard
    Clipboard.copy account.entity_name
  end

  def copy_password_to_clipboard
    account.password_store.copy_password_to_clipboard
  end

  def delete_account
    account.destroy
  end

end
