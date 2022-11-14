require_relative './config/boot'

pp Account.select('**/*.gpg').first.content
# pp FileFormats::PasswordStore.ancestors.split(ActiveFile::Format)