require_relative './lib/module'
require_relative './lib/active_file'

class PasswordStoreFormat < ActiveFile::Format
  def password
    `pass #{entity.path.delete_suffix('.gpg')}`
  end
end

class Account < ActiveFile::Base
  self.root_path = '/home/ubuntu/.password-store'
  # self.format = ActiveFile::Format
  self.format = PasswordStoreFormat
end

# pp Account.select('**/*.gpg').each { |account| puts account.name }
pp Account.select('**/*.gpg').each { |account| pp account.name, account.password }

Account.new()
