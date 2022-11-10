require 'forwardable'

require_relative './selector'
require_relative './format'
require_relative './utils'

class ActiveFile::Base
  class DoubleInitializationError < StandardError; end
  class InvalidFormat < StandardError; end
  class FormatterMethodConflict < StandardError; end

  extend Forwardable

  class << self
    attr_reader :root_path
    attr_reader :format

    def root_path=(path)
      raise DoubleInitializationError, "root_path is already initialized" if @root_path

      @root_path = path
    end

    def format=(format)
      raise DoubleInitializationError, "format is already initialized" if @format
      unless format.is_a?(Class) && format.ancestors.include?(ActiveFile::Format)
        raise InvalidFormat, "Expected an ActiveFile::Format < class, given #{formatter.pretty_inspect}"
      end

      @format = format
      @format.instance_methods(false).each do |format_method|
        if instance_methods.include?(format_method)
          raise FormatterMethodConflict, "Formatter method `#{format_method}` seems to be defined already in #{self.name}"
        end

        def_delegator :@format, format_method, format_method
      end
    end

    def select(path)
      ActiveFile::Selector.new(self, path)
    end

    def all
      select('**')
    end
  end

  attr_reader :path
  attr_internal_reader :format

  def initialize(path)
    @path = ActiveFile::Utils.clean_path(path)
    @format = self.class.format.new(self)
  end

  def name
    File.basename(path, File.extname(path))
  end

  def fullpath
    @fullpath ||= "#{self.class.root_path}/#{path}"
  end

end