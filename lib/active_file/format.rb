class ActiveFile::Format
  class NotHandleableEntity < StandardError; end

  attr_accessor :entity
  private :entity=

  def initialize(entity)
    unless entity.is_a? ActiveFile::Base
      raise NotHandleableEntity, "Expected an ActiveFile::Base object, given #{entity.pretty_print_inspect}"
    end

    self.entity = entity
  end

  class EntityClass

  end

end