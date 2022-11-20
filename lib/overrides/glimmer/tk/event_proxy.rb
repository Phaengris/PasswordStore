require 'ostruct'

class Glimmer::Tk::EventProxy
  init_with_attributes :event

  public :event

  def data
    @data ||= OpenStruct.new(YAML.load(event.detail))
  end

  def key_data
    {
      char: event.char,
      keycode: event.keycode,
      keysym: event.keysym,
      keysym_num: event.keysym_num
    }
  end

end