require 'ostruct'

class Glimmer::Tk::EventProxy
  init_with_attributes :event

  public :event

  def data
    @data ||= OpenStruct.new(YAML.load(event.detail))
  end

  def ctrl?
    event.state == 4
  end

end