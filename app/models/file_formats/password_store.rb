class FileFormats::PasswordStore < ActiveFile::Format
  class PasswordStoreError < StandardError; end

  # Well, that's not so simple...
  # We can't use Open3.popen3 because of gpg-agent (or we have to do tricky things with it)
  # `pass show -c ...` blocks us for 45 sec (even more if gpg password)
  # `pass show -c ...` in a Ractor => the only way to get errors is Ractor#take => blocking again
  # TODO: find a non-blocking way to get errors
  def copy_password_to_clipboard
    Ractor.new(account_path) do |account_path|
      `pass show -c #{account_path}`
    end
  end

  def account_path
    @account_path = entity.path.delete_suffix('.gpg')
  end

end
