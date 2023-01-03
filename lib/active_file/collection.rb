require_relative './utils'

# TODO: migrate all string paths to Pathname
class ActiveFile::Collection
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

  def path
    raise UndeterminedCollection unless determined?

    paths.first
  end

  def abs_path_for(path)
    klass.root_path.join(ActiveFile::Utils.clean_path(path))
  end

  def determined?
    paths.one? && !paths.first.include?('*')
  end

  def collection?
    true
  end

  def entity?
    false
  end

  def name
    raise UndeterminedCollection unless determined?

    # path.basename
    File.basename(path)
  end

  def parent
    raise UndeterminedCollection unless determined?
    return nil if path.blank?

    new(klass, path, options)
  end

  def destroy
    # TODO: callbacks?
    if determined?
      FileUtils.rm_rf(abs_path_for(path))
    else
      # TODO: implement it... when we'll need it
      raise NotImplementedError, "Deleting of a undetermined collection is not implemented yet"
    end
  end

  private

  def build_list
    list = paths.map { |path| Dir.glob(abs_path_for(path)) }.flatten
    list.reject! { |entry| File.directory?(entry) }  if options[:only] == :entities
    list.reject! { |entry| File.file?(entry) }       if options[:only] == :collections
    list
  end

  def abs_to_local_path(abs_path)
    # abs_path = Pathname.new(abs_path) unless abs_path.is_a?(Pathname)
    # abs_path.relative_path_from(klass.root_path)

    abs_path.delete_prefix(klass.root_path.to_s)
  end

end
