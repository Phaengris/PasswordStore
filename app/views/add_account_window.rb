require 'ostruct'
require 'dry/validation'

class ViewModels::AddAccountWindow
  attr_accessor :domain,
                :account,
                :password_generated,
                :generated_password_length,
                :generated_password_alphanumerics_excluded,
                :password,
                :password_visible,
                :password_confirmation,
                :notes,
                :errors

  def initialize
    self.errors = Framework::ViewModels::Errors.new(%i[domain account password password_confirmation])

    self.password_generated = true
    self.generated_password_length = 16
    self.generated_password_alphanumerics_excluded = false
    self.password_visible = false
  end

  def action
    validate
    return unless errors.none?

    Account.new(Pathname.new(domain).join("#{account}.gpg"))
  end

  private

  def validate
    values = { account: account, password_generated: password_generated }
    values[:domain] = domain if domain.present?
    unless password_generated
      values[:password] = password
      values[:password_visible] = password_visible
      values[:password_confirmation] = password_confirmation if password_visible
    end
    errors.consume_contract_errors Contract.new.call(values).errors
  end

  class Contract < Dry::Validation::Contract
    params do
      optional(:domain).filled(:string)
      required(:account).filled(:string)
      required(:password_generated).filled(:bool)
      optional(:password).filled(:string)
      optional(:password_visible).filled(:bool)
      optional(:password_confirmation).filled(:string)
    end

    rule(:domain) do
      if values[:domain]
        key.failure('Can\'t start or end with a space') \
          if values[:domain].start_with?(' ') || values[:domain].end_with?(' ')
        begin
          ActiveFile::Utils.clean_path(values[:domain])
        rescue ActiveFile::Utils::PathOutsideOfRoot
          key.failure('Must be a valid path inside the store')
        end
      end
    end

    rule(:account) do
      key.failure('Can\'t start or end with a space') \
        if values[:account].start_with?(' ') || values[:account].end_with?(' ')
      key.failure('Can\'t start or end with a dot') \
        if values[:account].start_with?('.') || values[:account].end_with?('.')
      key.failure('Must not be a path') \
        if values[:account].include?('/')
    end

    rule(:password, :password_generated) do
      unless values[:password_generated]
        key.failure('Must not be empty') unless values[:password].present?
      end
    end

    rule(:password_confirmation, :password, :password_generated, :password_visible ) do
      if !values[:password_generated] && values[:password_visible]
        if values[:password].present?
          key.failure('Must match the password') if values[:password] != values[:password_confirmation]
        end
      end
    end
  end

end