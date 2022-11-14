class Zeitwerk::AddModulesWhenLoaded
  include Callable

  init_with_attributes :loader, :into, :modules

  def call
    loader.on_load do |cpath, value, abspath|
      next unless value.is_a?(Class)

      case into
      # TODO: when Class, Module
      when Regexp
        next unless into.match?(abspath)
      else
        raise ArgumentError, "Expected namespace as a class/module, or a regexp, given #{into.pretty_print_inspect}"
      end

      value.include *modules
    end
  end
end