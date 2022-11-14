class Account < ActiveFile::Base
  self.root_path = "#{ENV['HOME']}/.password-store"
  self.format = FileFormats::PasswordStore
end