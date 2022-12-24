require 'ostruct'

class Framework::ViewModelErrors < OpenStruct
  attr_internal_accessor :keys

  def initialize(keys)
    keys = keys.map(&:to_sym)

    if (forbidden_keys = keys & self.class.instance_methods(false)).any?
      raise ArgumentError, <<-MSG.squish.strip
          Can't use #{forbidden_keys.map { |key| "\"#{key}\"" }
                                    .to_sentence(two_words_connector: 'or', last_word_connector: 'or')}
          as #{forbidden_keys.one? ? 'a key' : 'keys'}
      MSG
    end

    self.keys = keys

    super keys.map { |key| [key, nil] }.to_h
  end

  def any?
    self.keys.each { |key| return true if self.send(key).present? }
    false
  end

  def none?
    !any?
  end

  def consume_contract_errors(contract_errors)
    contract_errors = contract_errors.to_h
    self.keys.each { |key| self.send("#{key}=", contract_errors[key]&.to_sentence&.capitalize) }
  end
  alias_method :from_contract, :consume_contract_errors
end
