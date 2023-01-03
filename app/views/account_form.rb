require 'dry/validation'

class ViewModels::AccountForm
  attr_accessor :domain,
                :account,
                :password_generated,
                :password_length,
                :password_no_symbols,
                :password,
                :password_visible,
                :password_confirmation,

                :changes,
                :errors
  private :changes=
  private :errors=

  alias_method :password_generated?, :password_generated
  alias_method :password_no_symbols?, :password_no_symbols

  def account_path=(value)
    if value.present?
      Account.find(value).tap do |account|
        self.domain = account.collection_path
        self.account = account.name
        self.password_generated = false
        self.password = account.password_store.fetch_password
        self.password_confirmation = self.password.dup
        self.changes = Framework::ViewModelChanges.new(self, :domain, :account, :password)
      end
    else
      # TODO: should we expect un-setting account data?
      raise NotImplementedError
    end
  end

  def initialize
    self.errors = Framework::ViewModelErrors.new(%i[domain account password password_confirmation])

    self.password_generated = true
    self.password_length = 16
    self.password_no_symbols = false
    self.password_visible = false
  end

  def valid?
    validate
    errors.none?
  end

  # TODO: memoize?
  def account_path
    Pathname.new(domain).join("#{account}.gpg")
  end

  private

  def validate
    values = { account: account, password_generated: password_generated }
    values[:domain] = domain if domain.present?
    unless password_generated?
      values[:password] = password
      values[:password_visible] = password_visible
      values[:password_confirmation] = password_confirmation unless password_visible
    end
    errors.call_contract(Contract, values)
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