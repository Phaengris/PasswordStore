class Account < ActiveFile::Base
  self.root_path = "#{ENV['HOME']}/.password-store"
  self.add_format FileFormats::PasswordStore
end