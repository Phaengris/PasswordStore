class ViewModels::MainWindowComponents::AccountViewComponents::DeleteAccount
  attr_accessor :code,
                :code_confirmation

  def regenerate_code
    self.code = 4.times.map { |_| CHARACTERS[rand(CHARACTERS.length)] }.join
    self.code_confirmation = ''
  end

  private

  CHARACTERS = (('a'..'z').to_a + ('0'..'9').to_a).map(&:freeze).freeze

end