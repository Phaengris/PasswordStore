class ViewModels::EditAccountWindow
  include Glimte::Utils::Attr

  attr_accessor :account_path
  attr_internal_accessor :account

  # TODO: make more "view-friendly" aliases? not `entity_name`, but `account` etc?
  delegate :name, :collection_path, to: :account, allow_nil: true

  on_attr_write :account_path do |value|
    self.account = Account.find(value) if value
  end

  def update_account(form_view_model)
    account = Account.find(account_path)

    # TODO: migrate paths to Pathname, then get rid of to_s here
    if form_view_model.account_path.to_s != account_path.to_s
      account.move(form_view_model.account_path)
    end

    if form_view_model.password_generated?
      account
        .password_store
        .save_with_generated_password(length: form_view_model.password_length,
                                      no_symbols: form_view_model.password_no_symbols?)

    elsif form_view_model.changes.password?
      account.password_store.save_with_password(form_view_model.password)
    end
  end

end