class ActiveFile::Format
  class NotHandleableEntity < StandardError; end

  attr_reader :entity

  def initialize(entity)
    unless entity.is_a? ActiveFile::Base
      raise NotHandleableEntity, "Expected an ActiveFile::Base object, given #{entity.pretty_print_inspect}"
    end

    @entity = entity
  end

  def content
    File.read(entity.fullpath)
  end

end