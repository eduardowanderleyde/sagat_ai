class AccountNumberGenerator
  def self.generate
    SecureRandom.hex(6).upcase
  end
end 