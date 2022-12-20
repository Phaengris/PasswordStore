require_relative './collection'
require_relative './format'
require_relative './utils'

class ActiveFile::Base
  class NotInitialized < StandardError; end
  class DoubleInitialization < StandardError; end
  class InvalidFormat < StandardError; end

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
      where(ActiveFile::Utils.clean_path(path)).first # TODO: raise exception if not found?
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

  def initialize(path)
    self.path = ActiveFile::Utils.clean_path(path)
    self.class.formats.each do |format_class|
      # TODO: method name conflict?
      define_instance_reader(format_class.to_s.demodulize.underscore, format_class.new(self))
    end
  end

  memoize def entity_name
    File.basename(path, File.extname(path))
  end

  memoize def collection_path
    File.dirname(path)
  end

  memoize def collection_name
    File.basename(File.dirname(path))
  end

  memoize def abs_path
    self.class.root_path.join(path)
  end

  def entity?
    true
  end

  def collection?
    false
  end

  def content
    # TODO: raise a custom exception or just rely on FileNotFound?
    File.read(abs_path)
  end

end