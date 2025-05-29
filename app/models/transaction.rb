class Transaction < ApplicationRecord
  belongs_to :source_account, class_name: "BankAccount", optional: true
  belongs_to :destination_account, class_name: "BankAccount"

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true, inclusion: { in: %w[transfer deposit] }
  validates :status, presence: true, inclusion: { in: %w[pending completed failed] }
  validate :source_and_destination_different, if: -> { transaction_type == "transfer" }
  validate :source_account_has_sufficient_balance, on: :create, if: -> { transaction_type == "transfer" }

  before_validation :set_initial_status, on: :create

  def process!
    return if completed? || failed?

    Transaction.transaction do
      source_account.update_balance(-amount) if transaction_type == "transfer"
      destination_account.update_balance(amount)
      update!(status: "completed")
    end
  rescue ActiveRecord::RecordInvalid
    update!(status: "failed")
  end

  def completed?
    status == "completed"
  end

  def failed?
    status == "failed"
  end

  private

  def source_and_destination_different
    if source_account_id == destination_account_id
      errors.add(:base, "Conta de origem e destino não podem ser a mesma")
    end
  end

  def source_account_has_sufficient_balance
    if source_account.balance < amount
      errors.add(:base, "Saldo insuficiente para realizar a transferência")
    end
  end

  def set_initial_status
    self.status ||= "pending"
  end
end
