class ViewModels::MainWindowComponents::AccountsList
  TYPEABLE_CHARS = (
    ('a'..'z').to_a +
      [' '] +
      %w(` ~ ! @ # $ % ^ & * ( ) - _ = + [ { ] } \ | ; : ' " , < . > / ?)
  ).freeze

  attr_accessor :search_string
  attr_accessor :selected_account
  attr_accessor :selected_account_options
  attr_accessor :all_accounts_shown

  # private :search_string
  # private :selected_account_options=

  def initialize
    self.search_string = ''
  end

  def search_string=(str)
    @search_string = str

    entities_list = if search_string.strip.present?
                      # TODO: move this functionality into ActiveFile somehow
                      (
                        Account.select("**/#{search_mask}.gpg", only: :entities).map(&:full_name) +
                          Account.select("**/#{search_mask}/*.gpg", only: :entities).map(&:full_name)
                      )
                    else
                      Account.all.map(&:full_name)
                    end

    self.selected_account_options = build_tree_from_paths(entities_list)

    unless selected_account && tree_include_tree?(selected_account_options, selected_account)
      self.selected_account = if selected_account_options.first.is_a?(Hash)
                                [selected_account_options.first.keys.first]
                              else
                                [selected_account_options.first]
                              end
    else
      self.selected_account = selected_account # just reload
    end

    self.all_accounts_shown = search_string.strip.present?
  end

  # def select_prev
  #   i = selected_account_options.find_index(selected_account)
  #   if i.nil?
  #     self.selected_account = selected_account_options.last
  #   else
  #     self.selected_account = selected_account_options[i - 1] if i > 0
  #   end
  # end
  #
  # def select_next
  #   i = selected_account_options.find_index(selected_account)
  #   if i.nil?
  #     self.selected_account = selected_account_options.first
  #   else
  #     self.selected_account = selected_account_options[i + 1] if i < selected_account_options.count - 1
  #   end
  # end

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

  def build_tree_from_paths(list)
    tree = []

    list.uniq.sort.each do |item|
      keys = item.split('/')
      item_value = keys.pop

      node = tree
      keys.each do |key|
        subnode = node.find { |subnode| subnode.is_a?(Hash) && subnode.keys.first == key }
        node.push subnode = { key => [] } unless subnode
        node = subnode[key]
      end

      node.push(item_value)
    end

    tree
  end

  def tree_include_tree?(big_tree, small_tree)
    small_tree.each do |node|
      if node.is_a?(Hash)
        return false unless
          (sub_tree = big_tree.find { |sub_node| sub_node.is_a?(Hash) && sub_node.keys.first == node.keys.first }) &&
            tree_include_tree?(sub_tree, node)

      else
        return false unless
          big_tree.include?(node) ||
            big_tree.find { |sub_node| sub_node.is_a?(Hash) && sub_node.keys.first == node }
      end
    end
    true
  end

end