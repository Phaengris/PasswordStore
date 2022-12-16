require_relative './utils'

class ActiveFile::Selector
  include Enumerable

  class NotHandleableEntity < StandardError; end

  attr_internal_accessor :klass, :paths, :options

  def initialize(klass, path = '**', options = {})
    unless klass.is_a?(Class) && klass.ancestors.include?(ActiveFile::Base)
      raise NotHandleableEntity, "Expected an ActiveFile::Base > class, given #{klass.pretty_print_inspect}"
    end
    self.klass = klass
    self.paths = [ActiveFile::Utils.clean_path(path)]
    self.options = options
  end

  def each(&block)
    build_list.each do |entity_path|
      if File.directory?(entity_path)
        yield self.class.new(klass, local_path(entity_path))
      else
        yield klass.new(local_path(entity_path))
      end
    end
  end

  def or(path = '**')
    self.paths << ActiveFile::Utils.clean_path(path)
    self
  end

  def only(arg)
    case arg
    when :files then arg = :entities
    when :dirs  then arg = :collections
    end

    self.options[:only] = arg
    self
  end

  def full_path(path)
    "#{klass.root_path}/#{ActiveFile::Utils.clean_path(path)}"
  end

  def collection?
    true
  end

  def entity?
    false
  end

  def name
    # TODO better exceptions?
    raise "Can't determine name for a multi collection" unless paths.one?
    raise "Can't determine name for a selector collection" if (_name = paths.first.split('/').last).include?('*')
    _name
  end

  private

  def build_list
    list = paths.map { |path| Dir.glob(full_path(path)) }.flatten
    list.reject! { |entry| File.directory?(entry) }  if options[:only] == :entities
    list.reject! { |entry| File.file?(entry) }       if options[:only] == :collections
    list
  end

  def local_path(path)
    path.delete_prefix(klass.root_path)
  end

end