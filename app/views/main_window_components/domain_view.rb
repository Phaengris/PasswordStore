require 'clipboard'

class ViewModels::MainWindowComponents::DomainView
  attr_accessor :domain_path, :want_delete

  attr_internal_accessor :domain

  delegate :name, to: :domain, allow_nil: true

  on_attr_write(:domain_path) do |value|
    self.domain = Account.where(value).only(:collections).first if value.present?
  end

  def copy_domain_name_to_clipboard
    Clipboard.copy domain.name
  end

  def delete_domain
    domain.destroy
  end

end
