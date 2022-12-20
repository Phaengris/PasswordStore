require_relative './utils'

class ActiveFile::Collection
  # TODO: move all string paths to Pathname
  include Enumerable

  class NotHandleableEntity < StandardError; end
  class UndeterminedCollection < StandardError; end

  attr_internal_accessor :klass, :paths, :options

  def initialize(klass, path = '**', options = {})
    unless klass.is_a?(Class) && klass.ancestors.include?(ActiveFile::Base)
      raise NotHandleableEntity, "Expected an ActiveFile::Base > class, given #{klass.inspect}"
    end
    self.klass = klass
    self.paths = [ActiveFile::Utils.clean_path(path)]
    self.options = options
  end

  def each(&block)
    build_list.each do |path|
      if File.directory?(path)
        yield self.class.new(klass, abs_to_local_path(path), options)
      else
        yield klass.new(abs_to_local_path(path))
      end
    end
  end

  def or(path = '**')
    self.paths << ActiveFile::Utils.clean_path(path)
    self
  end

  def only(arg)
    # TODO: check for wrong values?
    case arg
    when :files then arg = :entities
    when :dirs  then arg = :collections
    end

    self.options[:only] = arg
    self
  end

  def abs_path(path)
    klass.root_path.join(ActiveFile::Utils.clean_path(path))
  end

  def collection?
    true
  end

  def entity?
    false
  end

  def name
    raise UndeterminedCollection, "More than one paths: #{paths.pretty_inspect}" unless paths.one?
    raise UndeterminedCollection, "Path contains wildcards: #{paths.first}" if paths.first.to_s.include?('*')
    paths.first.to_s.split('/').last
  end

  private

  def build_list
    list = paths.map { |path| Dir.glob(abs_path(path)) }.flatten
    list.reject! { |entry| File.directory?(entry) }  if options[:only] == :entities
    list.reject! { |entry| File.file?(entry) }       if options[:only] == :collections
    list
  end

  def abs_to_local_path(abs_path)
    abs_path.delete_prefix(klass.root_path.to_s)
  end

end