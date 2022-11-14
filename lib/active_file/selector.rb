require_relative './utils'

class ActiveFile::Selector
  include Enumerable

  class NotHandleableEntity < StandardError; end

  attr_internal_reader :klass
  attr_internal_reader :path
  attr_internal_reader :options

  def initialize(klass, path = '**', options = {})
    unless klass.is_a?(Class) && klass.ancestors.include?(ActiveFile::Base)
      raise NotHandleableEntity, "Expected an ActiveFile::Base > class, given #{klass.pretty_print_inspect}"
    end
    @_klass = klass
    @_path = ActiveFile::Utils.clean_path(path)
    @_options = options
  end

  def each(&block)
    Dir.glob(full_path).each do |entity_path|
      if Dir.exist?(entity_path)
        next if options[:only] == :entities

        yield self.class.new(klass, local_path(entity_path))
      else
        yield klass.new(local_path(entity_path))
      end
    end
  end

  def full_path
    @_full_path ||= "#{klass.root_path}/#{path}"
  end

  private

  def local_path(path)
    path.delete_prefix(klass.root_path)
  end

end