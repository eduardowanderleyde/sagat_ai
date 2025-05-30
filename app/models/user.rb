class User < ApplicationRecord
  has_secure_password
  has_one :bank_account, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :cpf, presence: true, uniqueness: true, format: { with: /\A\d{11}\z/, message: "must contain 11 digits" }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validate :valid_cpf

  before_validation :strip_cpf

  private

  def strip_cpf
    self.cpf = cpf.gsub(/\D/, "") if cpf.present?
  end

  def valid_cpf
    return if cpf.blank?
    return if cpf.length != 11
    return if cpf.chars.uniq.length == 1

    sum = 0
    9.times do |i|
      sum += cpf[i].to_i * (10 - i)
    end
    digit1 = (sum * 10 % 11) % 10
    return errors.add(:cpf, "invalid") if digit1 != cpf[9].to_i


    sum = 0
    10.times do |i|
      sum += cpf[i].to_i * (11 - i)
    end
    digit2 = (sum * 10 % 11) % 10
    errors.add(:cpf, "invalid") if digit2 != cpf[10].to_i
  end
end
