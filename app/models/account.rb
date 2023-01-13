require 'active_file'

class Account < ActiveFile::Base
  include Glimte::Utils::Attr

  self.root_path = "#{ENV['HOME']}/.password-store"
  self.add_format FileFormats::PasswordStore

  # TODO: !!!temporary!!! PasswordStore should handle that
  def self.password_store
    Struct.new(:gpg_id).new(Account.new('').password_store.send(:gpg_id))
  end
end