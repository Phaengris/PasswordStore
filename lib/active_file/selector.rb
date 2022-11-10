require_relative './utils'

class ActiveFile::Selector
  include Enumerable

  class NotHandleableEntity < StandardError; end

  attr_internal_reader :klass
  attr_internal_reader :path

  def initialize(klass, path = '**')
    unless klass.is_a?(Class) && klass.ancestors.include?(ActiveFile::Base)
      raise NotHandleableEntity, "Expected an ActiveFile::Base > class, given #{klass.pretty_print_inspect}"
    end
    @klass = klass
    @path = ActiveFile::Utils.clean_path(path)
  end

  def each(&block)
    Dir.glob(fullpath).each do |entity_path|
      if Dir.exist?(entity_path)
        yield self.class.new(klass, local_path(entity_path))
      else
        yield klass.new(local_path(entity_path))
      end
    end
  end

  def fullpath
    @fullpath ||= "#{klass.root_path}/#{path}"
  end

  private

  def local_path(path)
    path.delete_prefix(klass.root_path)
  end

end