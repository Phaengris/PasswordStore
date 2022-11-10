class Account < ActiveFile::Base
  self.root_path = "#{ENV['HOME']}/.password-store"
  self.format = :password_store
end