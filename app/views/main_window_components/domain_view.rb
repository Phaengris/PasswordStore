require 'clipboard'

class ViewModels::MainWindowComponents::DomainView
  attr_accessor :domain_path

  attr_internal_accessor :domain

  delegate :name, to: :domain, allow_nil: true

  on_attr_write(:domain_path) do |value, previous_value|
    puts "DomainView <= domain_path = #{value}"
    self.domain = Account.where(value).only(:collections).first if value.present?
  end

  def copy_domain_name_to_clipboard
    Clipboard.copy domain.name
  end

end
