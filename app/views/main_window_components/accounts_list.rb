class ViewModels::MainWindowComponents::AccountsList
  attr_accessor :search_string
  attr_accessor :selection
  attr_accessor :selection_options
  attr_accessor :selection_path
  attr_accessor :selection_is_account
  alias_method :selection_is_account?, :selection_is_account

  private :selection_path=

  def initialize
    self.search_string = ''
  end

  on_attr_write(:search_string) do |value, previous_value|
    _debug(search_string: value)
    entities_list = if value.strip.present?
                      Account
                        .where("**/#{search_mask}.gpg")
                        .or("**/#{search_mask}/*.gpg")
                        .only(:entities)
                        .map(&:path)
                    else
                      Account.all.map(&:path)
                    end

    self.selection_options = build_tree_from_paths(entities_list)
    self.selection = locate_match_in_tree(selection_options, search_regexp) || []
  end

  on_attr_write(:selection) do |value, previous_value|
    self.selection_path = build_path_from_branch(value)
    self.selection_is_account = Account.entity?(build_path_from_branch(value))
  end

  # on_attr_write(:selection_path) do |value, previous_value|
  #
  # end

  alias_method :selection_is_account_value, :selection_is_account
  def selection_is_account
    selection_is_account_value
  end

  def reload
    # TODO: let's do it straightforward for now :)
    self.search_string = self.search_string
  end

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