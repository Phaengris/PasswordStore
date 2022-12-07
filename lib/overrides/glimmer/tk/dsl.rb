require_relative './treeview_selection_data_binding_expression'

module Glimmer
  module DSL
    handler = ExpressionHandler.new(Tk::TreeviewSelectionDataBindingExpression.new)
    handler.next = Engine.dynamic_expression_chains_of_responsibility[:tk]
    Engine.dynamic_expression_chains_of_responsibility[:tk] = handler
  end
end
