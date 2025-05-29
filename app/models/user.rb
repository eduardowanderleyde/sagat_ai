class User < ApplicationRecord
  has_secure_password
  has_one :bank_account, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :cpf, presence: true, uniqueness: true, format: { with: /\A\d{11}\z/, message: "deve conter 11 dígitos" }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  before_validation :strip_cpf

  private

  def strip_cpf
    self.cpf = cpf.gsub(/\D/, "") if cpf.present?
  end
end
