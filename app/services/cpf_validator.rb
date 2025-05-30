class CpfValidator
  def self.valid?(cpf)
    return false if cpf.blank?
    return false if cpf.length != 11
    return false if cpf.chars.uniq.length == 1

    digit1 = calculate_digit(cpf, 10)
    return false if digit1 != cpf[9].to_i

    digit2 = calculate_digit(cpf, 11)
    digit2 == cpf[10].to_i
  end

  private

  def self.calculate_digit(cpf, factor)
    sum = 0
    (factor - 1).times do |i|
      sum += cpf[i].to_i * (factor - i)
    end
    (sum * 10 % 11) % 10
  end
end
