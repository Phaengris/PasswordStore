require 'clipboard'

class ViewModels::MainWindowComponents::AccountView
  include Glimte::Utils::Attr

  attr_accessor :account_path,
                :want_delete,
                :password

  attr_internal_accessor :account

  on_attr_write(:account_path) do |value|
    self.account = Account.find(value) if value.present?
  end

  # TODO: make more "view-friendly" aliases? not `entity_name`, but `account` etc?
  delegate :name,
           :collection_name,
           :collection_path,
           to: :account,
           allow_nil: true

  def copy_domain_name_to_clipboard
    Clipboard.copy account.collection_name
  end

  def copy_account_name_to_clipboard
    Clipboard.copy account.name
  end

  def copy_password_to_clipboard
    account.password_store.copy_password_to_clipboard
  end

  def show_or_hide_password
    if password.present?
      # TODO: wipe the value?
      self.password = nil
    else
      self.password = account.password_store.fetch_password
    end
  end

  def delete_entity
    account.destroy
  end

end
