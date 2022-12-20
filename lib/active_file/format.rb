class ActiveFile::Format
  class NotHandleableEntity < StandardError; end

  def self.provided_methods
    ActiveFile::Format.instance_methods(false) +
      ancestors.split(ActiveFile::Format)[0].map { |klass| klass.instance_methods(false) }.flatten
  end

  attr_reader :entity

  def initialize(entity)
    unless entity.is_a? ActiveFile::Base
      raise NotHandleableEntity, "Expected an ActiveFile::Base object, given #{entity.pretty_print_inspect}"
    end

    @entity = entity
  end

  def content
    File.read(entity.abs_path)
  end

end