require 'ostruct'
require 'dry/validation'

class ViewModels::AddAccountWindow
  attr_accessor :domain,
                :account,
                :password_generated,
                :generate_password_state,
                :generated_password_length,
                :generated_password_alphanumerics_excluded,
                :password,
                :password_visible,
                :password_hide_char,
                :password_focus,
                :password_confirmation,
                :password_confirmation_visible,
                :password_entries_state,
                :errors

  def initialize
    self.errors = OpenStruct.new(domain: nil, account: nil, password: nil, password_confirmation: nil)

    self.password_generated = true
    self.generate_password_state = 'enabled'
    self.generated_password_length = 16
    self.generated_password_alphanumerics_excluded = false
    self.password_visible = false
    self.password_entries_state = 'disabled'
  end

  alias_method :password_generated_attr=, :password_generated=
  def password_generated=(value)
    if value
      self.generate_password_state = 'enabled'
      self.password_entries_state = 'disabled'
      self.errors.password = nil
      self.errors.password_confirmation = nil
    else
      self.generate_password_state = 'disabled'
      self.password_entries_state = 'enabled'
      self.password_focus = true
    end
    self.password_generated_attr = value
  end

  alias_method :password_visible_attr=, :password_visible=
  def password_visible=(value)
    if value
      self.password_hide_char = nil
      self.password_confirmation_visible = false
    else
      self.password_hide_char = '*'
      self.password_confirmation_visible = true
    end
    self.password_visible_attr = value
  end

  def validate
    values = { account: account, password_generated: password_generated }
    values[:domain] = domain if domain.present?
    unless password_generated
      values[:password] = password
      values[:password_visible] = password_visible
      values[:password_confirmation] = password_confirmation if password_visible
    end
    errors = AccountFormContract.new.call(values).errors.to_h
    self.errors.account               = errors[:account]&.to_sentence&.capitalize
    self.errors.domain                = errors[:domain]&.to_sentence&.capitalize
    self.errors.password              = errors[:password]&.to_sentence&.capitalize
    self.errors.password_confirmation = errors[:password_confirmation]&.to_sentence&.capitalize
  end

  class AccountFormContract < Dry::Validation::Contract
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