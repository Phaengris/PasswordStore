class Ractor
  class StatusDetectingError < StandardError; end

  def status
    case self.to_s
    when /running/ then :running
    when /blocking/ then :blocking
    when /terminated/ then :terminated
    else
      raise StatusDetectingError, "Failed to detect status of #{self.to_s} - any changes in Ruby implementation?"
    end
  end

  def running?
    status == :running
  end

  def blocking?
    status == :blocking
  end

  def terminated?
    status == :terminated
  end

end
