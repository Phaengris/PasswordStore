require 'gpgme'
require 'clipboard'

class FileFormats::PasswordStore < ActiveFile::Format
  class PasswordStoreError < StandardError; end

  CHARACTERS = (('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a).join.freeze
  SYMBOLS = "`~!@\#$%^&*()-_=+[{]};:'\",<.>/?".freeze

  def write_password(password, notes: nil)
    content = "#{password}\n#{"#{notes}\n" if notes.present?}"
    begin
      File.write(abs_path, GPGME::Crypto.new.encode(content, recipients: gpg_id))
    ensure
      wipe_string_variable(password)
      wipe_string_variable(notes)
      wipe_string_variable(content)
    end
    nil
  end

  def autogenerate_password(length: 16, no_symbols: false, notes: nil)
    set = CHARACTERS.dup
    set += SYMBOLS unless no_symbols
    write_password(length.times.map { |_| set[rand(set.length)] }.join, notes: notes)
    nil
  end

  def copy_password_to_clipboard
    password = fetch_password
    password_digest = Digest::SHA1.hexdigest(password)
    Clipboard.copy(password)
    wipe_string_variable(password)

    Thread.new(password_digest) do |password_digest|
      sleep 30

      if Digest::SHA1.hexdigest(Clipboard.paste) == password_digest
        Clipboard.clear
      end
    end

    nil
  end

  private

  def fetch_password
    decrypted = GPGME::Crypto.new.decrypt(entity.content).to_s
    decrypted_lines = decrypted.split("\n")
    raw_password = decrypted_lines[0]
    password = raw_password.strip

    wipe_string_variable(decrypted)
    wipe_string_variable(raw_password)
    decrypted_lines.each { |line| wipe_string_variable(line) }

    password
  end

  def wipe_string_variable(var)
    var.length.times { |i| var[i] = "\0" }
    nil
  end

  def gpg_id
    raise PasswordStoreError, "#{gpg_id_path} not found" unless File.exist?(gpg_id_path)

    File.read(gpg_id_path)
  end

  memoize def gpg_id_path
    entity.class.root_path.join('.gpg-id')
  end

end
