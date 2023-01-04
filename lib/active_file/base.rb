require_relative './collection'
require_relative './format'
require_relative './utils'

class ActiveFile::Base
  class NotInitialized < StandardError; end
  class DoubleInitialization < StandardError; end
  class InvalidFormat < StandardError; end
  class EntityNotFound < StandardError; end

  class << self
    def root_path=(path)
      raise DoubleInitialization, "root_path is already initialized as #{root_path}" if @root_path

      @root_path = Pathname.new(path)
    end

    def root_path
      @root_path ||
        (raise NotInitialized, 'Use `self.root_path =` in your ActiveFile::Base < class to define the root path')
    end

    def add_format(format)
      unless format.is_a?(Class) && format.ancestors.include?(ActiveFile::Format)
        raise InvalidFormat, "Expected an ActiveFile::Format < class, given #{format.inspect}"
      end

      @formats ||= []
      @formats << format
    end

    def formats
      (@formats ||= []).dup
    end

    def where(path, options = {})
      ActiveFile::Collection.new(self, path, options)
    end

    # TODO: or `all_entities`?
    def all
      where('**/*', only: :entities)
    end

    def find(path)
      where(ActiveFile::Utils.clean_path(path)).only(:entities).first || raise(EntityNotFound, "Can't find #{path}")
    end

    def entity?(path)
      File.file?("#{root_path}/#{ActiveFile::Utils.clean_path(path)}")
    end

    def collection?(path)
      File.directory?("#{root_path}/#{ActiveFile::Utils.clean_path(path)}")
    end
  end

  attr_accessor :path
  private :path=

  # TODO: migrate all string paths to Pathname
  def initialize(path)
    self.path = ActiveFile::Utils.clean_path(path)
    self.class.formats.each do |format_class|
      # TODO: method name conflict?
      define_instance_reader(format_class.to_s.demodulize.underscore, format_class.new(self))
    end
  end

  def persisted?
    File.exists?(abs_path)
  end

  def content
    # TODO: raise a custom exception or just rely on Errno::ENOENT?
    File.read(abs_path)
  end

  def content=(value)
    unless Dir.exists?(collection_abs_path)
      raise "Collection / entity paths conflict" if File.file?(collection_abs_path)
      FileUtils.mkdir_p(collection_abs_path)
    end

    File.write(abs_path, value)
  end

  # TODO: through `path=` setter?
  def move(new_path)
    new_path = ActiveFile::Utils.clean_path(new_path)

    new_collection_abs_path = self.class.root_path.join(File.dirname(new_path))
    unless Dir.exists?(new_collection_abs_path)
      raise "Collection / entity paths conflict" if File.file?(new_collection_abs_path)
      FileUtils.mkdir_p(new_collection_abs_path)
    end

    # TODO: rely on FileUtils.move or raise our own exception?
    FileUtils.move(abs_path, self.class.root_path.join(new_path))

    self.path = new_path
    unmemoize :name
    unmemoize :path
    unmemoize :abs_path
    unmemoize :collection_name
    unmemoize :collection_path
    unmemoize :collection_abs_path
  end

  memoize def name
    File.basename(path, File.extname(path))
  end

  # TODO: we don't want `path` to be changed outside
  # memoize def path
  #   self.path.dup
  # end

  memoize def abs_path
    self.class.root_path.join(path)
  end

  memoize def collection_name
    File.basename(collection_path)
  end

  memoize def collection_path
    path.include?('/') ? File.dirname(path) : ''
  end

  memoize def collection_abs_path
    File.dirname(abs_path)
  end

  def entity?
    true
  end

  def collection?
    false
  end

  def destroy
    # TODO: callbacks?
    File.delete(abs_path)
  end

end