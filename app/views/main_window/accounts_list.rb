class ViewModels::MainWindow::AccountsList
  TYPEABLE_CHARS = (
    ('a'..'z').to_a +
      [' '] +
      %w(` ~ ! @ # $ % ^ & * ( ) - _ = + [ { ] } \ | ; : ' " , < . > / ?)
  ).freeze

  attr_accessor :search_terms
  attr_accessor :search_entry_focused
  attr_accessor :selected_account
  attr_accessor :selected_account_options

  private :search_terms=
  private :selected_account_options=

  def initialize
    self.search_terms = ''
  end

  def search_terms=(str)
    @search_terms = str
    self.selected_account_options = if search_terms.strip.present?
                                      Account.select("**/#{search_mask}", only: :entities).map(&:full_name)
                                    else
                                      Account.all.map(&:full_name)
                                    end
    self.selected_account = selected_account_options.first unless selected_account_options.include?(selected_account)
    self.search_entry_focused = true
  end

  def search_entry_keypress(event)
    case event.keysym
    when 'Escape'
      if search_terms.blank?
        Framework.exit
      else
        self.search_terms = ''
      end
    when 'Up'
      i = selected_account_options.find_index(selected_account)
      self.selected_account = selected_account_options[i - 1] if i > 0
    when 'Down'
      i = selected_account_options.find_index(selected_account)
      self.selected_account = selected_account_options[i + 1] if i < selected_account_options.count - 1
    end
  end

  def accounts_list_keypress(event)
    case event.keysym
    when 'Escape'
      self.search_terms = '' unless search_terms.blank?
    else
      return unless TYPEABLE_CHARS.include?(event.char.downcase)
      self.search_terms += event.char
    end
  end

  private

  def search_mask
    '*' + search_terms.strip.split(/[\/\s]+/).reject(&:blank?).join('*') + '*'
  end

end