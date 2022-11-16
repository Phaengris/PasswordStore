class Sequence

  def initialize(&block)
    @index = nil
    yield self if block_given?
  end

  def next
    return (@index = 0) if @index.nil?

    @index += 1
  end

end