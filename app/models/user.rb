module CpfValidatable
  extend ActiveSupport::Concern

  included do
    validate :valid_cpf
    before_validation :strip_cpf
  end

  private

  def strip_cpf
    self.cpf = cpf.gsub(/\D/, "") if cpf.present?
  end

  def valid_cpf
    return if cpf.blank?
    return if cpf.length != 11
    return if cpf.chars.uniq.length == 1

    unless CpfValidator.valid?(cpf)
      errors.add(:cpf, "invalid")
    end
  end
end

class User < ApplicationRecord
  include CpfValidatable
  has_secure_password
  has_one :bank_account, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :cpf, presence: true, uniqueness: true, format: { with: /\A\d{11}\z/, message: "must contain 11 digits" }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end
