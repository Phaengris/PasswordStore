scenario_for 'main_window' do
  Views.edit_domain_window { domain_path Account.where('**/*').only(:collections).first.path }
end
