class ViewModels::MainWindowComponents::DomainView
  attr_accessor :domain_path

  attr_internal_accessor :domain

  alias_method :domain_path_attr=, :domain_path=
  def domain_path=(path)
    self.domain = Account.find(path)
    self.domain = nil unless self.domain.collection?
    self.domain_path_attr = path
  end

  delegate :name,
           to: :domain,
           allow_nil: true
end
