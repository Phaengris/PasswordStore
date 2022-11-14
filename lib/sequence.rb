class Sequence

  def initialize(&block)
    @index = nil
    yield self
  end

  def next
    return (@index = 0) if @index.nil?

    @index + 1
  end

end