class ViewModels::MainWindowComponents::AccountsList
  TYPEABLE_CHARS = (
    ('a'..'z').to_a +
      [' '] +
      %w(` ~ ! @ # $ % ^ & * ( ) - _ = + [ { ] } \ | ; : ' " , < . > / ?)
  ).freeze

  attr_accessor :search_string
  attr_accessor :search_entry_focused
  attr_accessor :selected_account
  attr_accessor :selected_account_options

  private :search_string
  private :selected_account_options=

  def initialize
    self.search_string = ''
  end

  def search_string=(str)
    @search_string = str
    self.selected_account_options = if search_string.strip.present?
                                      # TODO: move this functionality into ActiveFile somehow
                                      (
                                        Account.select("**/#{search_mask}.gpg", only: :entities).map(&:full_name) +
                                          Account.select("**/#{search_mask}/*.gpg", only: :entities).map(&:full_name)
                                      ).uniq.sort
                                    else
                                      Account.all.map(&:full_name)
                                    end
    self.selected_account = selected_account_options.first unless selected_account_options.include?(selected_account)
    self.search_entry_focused = true
  end

  def select_prev
    i = selected_account_options.find_index(selected_account)
    if i.nil?
      self.selected_account = selected_account_options.last
    else
      self.selected_account = selected_account_options[i - 1] if i > 0
    end
  end

  def select_next
    i = selected_account_options.find_index(selected_account)
    if i.nil?
      self.selected_account = selected_account_options.first
    else
      self.selected_account = selected_account_options[i + 1] if i < selected_account_options.count - 1
    end
  end

  # TODO: move to the toolbar
  # def accounts_list_keypress(event)
  #   case event.keysym
  #   when 'Escape'
  #     self.search_string = '' unless search_string.blank?
  #   else
  #     return unless TYPEABLE_CHARS.include?(event.char.downcase)
  #     self.search_string += event.char
  #   end
  # end

  def selected_account_path
    return nil unless selected_account.present?

    "#{selected_account}.gpg"
  end

  private

  def search_mask
    '*' + search_string.strip.split(/[\/\s]+/).reject(&:blank?).join('*') + '*'
  end

end