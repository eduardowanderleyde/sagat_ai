class BankAccount < ApplicationRecord
  belongs_to :user
  has_many :source_transactions, class_name: "Transaction", foreign_key: "source_account_id"
  has_many :destination_transactions, class_name: "Transaction", foreign_key: "destination_account_id"
  has_many :scheduled_transactions, foreign_key: "source_account_id"

  validates :account_number, presence: true, uniqueness: true
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :agency, presence: true, format: { with: /\A\d{4}\z/, message: "must contain 4 digits" }

  before_validation :generate_account_number, on: :create

  def update_balance(amount)
    with_lock do
      new_balance = balance + amount
      raise ActiveRecord::RecordInvalid.new(self), "Insufficient balance" if new_balance < 0
      update!(balance: new_balance)
    end
  end

  private

  def generate_account_number
    self.account_number = AccountNumberGenerator.generate
  end
end
