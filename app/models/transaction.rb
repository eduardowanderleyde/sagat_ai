class Transaction < ApplicationRecord
  belongs_to :source_account, class_name: "BankAccount", optional: true
  belongs_to :destination_account, class_name: "BankAccount"

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true, inclusion: { in: %w[transfer deposit] }
  validates :status, presence: true, inclusion: { in: %w[pending completed failed] }
  validates :source_account, presence: true, if: -> { transaction_type == "transfer" }
  validate :source_and_destination_different, if: -> { transaction_type == "transfer" }
  validate :source_account_has_sufficient_balance, on: :create, if: -> { transaction_type == "transfer" }

  before_validation :set_initial_status, on: :create

  def process!
    return if completed? || failed?

    TransactionProcessor.process(self)
  end

  def completed?
    status == "completed"
  end

  def failed?
    status == "failed"
  end

  private

  def source_and_destination_different
    if transaction_type == "transfer" && source_account_id == destination_account_id
      errors.add(:base, "Source and destination account cannot be the same")
    end
  end

  def source_account_has_sufficient_balance
    if source_account.balance < amount
      errors.add(:base, "Insufficient balance to make the transfer")
    end
  end

  def set_initial_status
    self.status ||= "pending"
  end
end
