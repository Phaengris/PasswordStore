class ViewModels::AddAccountWindow

  def add_account(form_view_model)
    account = Account.new(form_view_model.account_path)

    if form_view_model.password_generated?
      account
        .password_store
        .save_with_generated_password(length: form_view_model.password_length,
                                      no_symbols: form_view_model.password_no_symbols?)

    else
      account.password_store.save_with_password(form_view_model.password)
    end
  end

end