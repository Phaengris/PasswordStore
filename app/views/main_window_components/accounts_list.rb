class ViewModels::MainWindowComponents::AccountsList
  TYPEABLE_CHARS = (
    ('a'..'z').to_a +
      [' '] +
      %w(` ~ ! @ # $ % ^ & * ( ) - _ = + [ { ] } \ | ; : ' " , < . > / ?)
  ).freeze

  attr_accessor :search_string
  attr_accessor :selection
  attr_accessor :selection_options
  attr_accessor :selection_path
  attr_accessor :all_accounts_shown

  # private :search_string
  # private :selected_account_options=
  private :selection_path=

  def initialize
    self.search_string = ''
  end

  alias_method :selection_attr=, :selection=
  def selection=(branch)
    self.selection_path = build_path_from_branch(branch)
    self.selection_attr = branch
  end

  def search_string=(str)
    @search_string = str

    entities_list = if search_string.strip.present?
                      Account
                        .where("**/#{search_mask}.gpg")
                        .or("**/#{search_mask}/*.gpg")
                        .only(:entities)
                        .map(&:path)
                    else
                      Account.all.map(&:path)
                    end

    self.selection_options = build_tree_from_paths(entities_list)

    # if selected_account && tree_include_tree?(selected_account_options, selected_account)
    #   self.selected_account = selected_account # just reload
    # else
    #   self.selected_account = locate_match_in_tree(selected_account_options, search_regexp) || []
    # end
    self.selection = locate_match_in_tree(selection_options, search_regexp) || []

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

  def selection_is_account?
    Account.entity?(selection_path)
  end
  alias_method :account_selected?, :selection_is_account?

  def selection_is_domain?
    Account.collection?(selection_path)
  end
  alias_method :domain_selected?, :selection_is_domain?

  private

  def search_mask
    '*' + search_string.strip.split(/[\/\s]+/).reject(&:blank?).join('*') + '*'
  end

  def search_regexp
    Regexp.new(search_string.strip.split(/[\/\s]+/).reject(&:blank?).map { |part| Regexp.quote(part) }.join('.*'))
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

  def build_path_from_branch(branch)
    path = []
    node = branch.first
    if node.is_a?(Hash)
      path << node.keys.first
      path << build_path_from_branch(node.values.first)
    else
      path << node
    end
    path.join('/')
  end

  # def tree_include_tree?(big_tree, small_tree)
  #   small_tree.each do |node|
  #     if node.is_a?(Hash)
  #       return false unless
  #         (sub_tree = big_tree.find { |sub_node| sub_node.is_a?(Hash) && sub_node.keys.first == node.keys.first }) &&
  #           tree_include_tree?(sub_tree, node)
  #
  #     else
  #       return false unless
  #         big_tree.include?(node) ||
  #           big_tree.find { |sub_node| sub_node.is_a?(Hash) && sub_node.keys.first == node }
  #     end
  #   end
  #   true
  # end

  def locate_match_in_tree(tree, regexp)
    tree.each do |node|
      if node.is_a?(Hash)
        if node.keys.first.match?(regexp)
          return [node.keys.first]
        else
          match = locate_match_in_tree(node.values.first, regexp)
          return [{ node.keys.first => match }] if match
        end
      else
        return [node] if node.match?(regexp)
      end
    end
  end

  # def tree_branch_reaches_leaf?(tree, branch)
  #   node = branch.first
  #   if node.is_a?(Hash)
  #     sub_tree = tree.find { |sub_tree| sub_tree.is_a?(Hash) && sub_tree.keys.first == node.keys.first }
  #     sub_tree && tree_branch_reaches_leaf?(sub_tree.values.first, node.values.first)
  #   else
  #     tree.include? node
  #   end
  # end

end