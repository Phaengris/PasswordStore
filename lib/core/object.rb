require 'memoized'
require 'pastel'

class Object
  include Memoized

  class << self

    def init_with_attributes(*attributes)
      attr_internal_accessor *attributes

      define_method :initialize do |*args|
        args = args.first if args.is_a?(Array) && args.one? && args.first.is_a?(Hash)

        case args
        when Hash
          args.each do |attr, val|
            raise ArgumentError, "Unexpected attribute `#{attr}`" unless attributes.include?(attr)

            send("#{attr}=", val)
          end
        when Array
          if args.count > attributes.count
            raise ArgumentError,
                  "Expected only #{attributes.count} #{"argument".pluralize(attributes.count)}, got #{args.count}"
          end

          attributes.each_with_index { |attr, i| send("#{attr}=", args[i]) }
        else
          raise ArgumentError, "Sorry, not sure how to process #{args.pretty_inspect}"
        end
      end
    end

    def on_attr_write(attr, &block)
      unless instance_methods(false).include?("#{attr}=".to_sym)
        raise ArgumentError,
              "Writer for attr `#{attr}` is not defined. Use `attr_writer :#{attr}` or `attr_accessor :#{attr}` to define it."
      end
      if instance_methods(false).include?("#{attr}__skip_callback=".to_sym)
        raise ArgumentError,
              "`on_attr_write` handler for attr `#{attr}` is already defined. Multiple handlers aren't supported at the moment."
      end

      alias_method "#{attr}__skip_callback=", "#{attr}="

      define_method "#{attr}=" do |value|
        previous_value = send(attr) if respond_to?(attr)
        send("#{attr}__skip_callback=", value)
        instance_exec(value, previous_value, &block)
      end
    end
  end

  def define_instance_reader(name, value)
    define_singleton_method name do
      value
    end
  end

  def _debug(msg_or_data = nil, data = {})
    # return unless Framework::Dev::Scene.watched?

    if msg_or_data.is_a?(Hash)
      msg = nil
      data = msg_or_data
    else
      msg = msg_or_data
    end

    header = 'DEBUG'
    class_name = self.class.to_s
    method_name_separator = self.is_a?(Class) ? '.' : '#'
    method_name = Kernel.caller.first.match(/in `([^']+)'/)[1]
    # view_path = if method_name == 'closest_view'
    #               nil
    #             elsif self.is_a?(Glimmer::Tk::WidgetProxy)
    #               self.closest_view.view_path
    #             elsif Glimmer::DSL::Engine.parent_stack.any?
    #               Glimmer::DSL::Engine.parent_stack.last.closest_view.view_path
    #             end
    formatted_data = if data.any?
                       data.map { |k, v|
                         v = v.inspect
                         v = v[0..150] + '...' + v[-1] if v.length > 150
                         [k, v]
                       }.to_h
                     end

    pastel = Pastel.new
    header = pastel.bright_cyan(header)
    class_name = pastel.white(class_name)
    method_name_separator = pastel.white(method_name_separator)
    method_name = pastel.bright_white(method_name)
    # if view_path
    #   view_path = '  ' + pastel.cyan(view_path + '->')
    # else
      class_name = '  ' + class_name
    # end
    msg = '  ' + pastel.bright_yellow(msg) + "\n" if msg
    formatted_data = if formatted_data
                       indent = formatted_data.keys.map(&:length).max + 4
                       formatted_data.map { |k, v|
                         ' ' * (indent - k.length) + pastel.bright_blue("- #{k}: ") + pastel.white(v)
                       }.join("\n")
                     end

    # puts "#{header}\n#{view_path}#{class_name}#{method_name_separator}#{method_name}\n#{msg}#{formatted_data}"
    puts "#{header}\n#{class_name}#{method_name_separator}#{method_name}\n#{msg}#{formatted_data}"
  end

end
