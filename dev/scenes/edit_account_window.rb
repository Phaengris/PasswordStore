scenario_for 'main_window' do
  Views.edit_account_window { account_path Account.all.first.path }
end
