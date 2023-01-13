require 'dry/validation'

class ViewModels::EditDomainWindow
  include Glimte::Utils::Attr

  attr_accessor :domain_path,
                :errors

  attr_internal_accessor :domain

  on_attr_write(:domain_path) do |value|
    next unless domain.nil?

    self.domain = Account.where(domain_path).only(:collections).first
  end

  def initialize
    self.errors = Glimte::ViewModelErrors.new(:domain_path)
  end

  def update_domain
    domain.move(domain_path) unless domain.path == domain_path
  end

  def valid?
    validate
    errors.none?
  end

  private

  def validate
    values = { domain_path: domain_path }
    errors.call_contract(Contract, values)
  end

  class Contract < Dry::Validation::Contract
    params do
      required(:domain_path).filled(:string)
    end

    rule(:domain_path) do
      key.failure('Can\'t start or end with a space') \
          if values[:domain_path].start_with?(' ') || values[:domain_path].end_with?(' ')
      begin
        ActiveFile::Utils.clean_path(values[:domain_path])
      rescue ActiveFile::Utils::PathOutsideOfRoot
        key.failure('Must be a valid path inside the store')
      end
    end
  end
end