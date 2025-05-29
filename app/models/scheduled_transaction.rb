class ScheduledTransaction < ApplicationRecord
  belongs_to :source_account, class_name: "BankAccount"
  belongs_to :destination_account, class_name: "BankAccount"

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :scheduled_for, presence: true
  validate :scheduled_for_must_be_in_future
  validate :source_account_has_sufficient_balance
  validate :source_and_destination_different

  private

  def scheduled_for_must_be_in_future
    return unless scheduled_for.present?

    if scheduled_for <= Time.current
      errors.add(:scheduled_for, "deve ser uma data futura")
    end
  end

  def source_account_has_sufficient_balance
    return unless source_account && amount.present?

    if source_account.balance < amount
      errors.add(:base, "saldo insuficiente para realizar a transferência")
    end
  end

  def source_and_destination_different
    if source_account_id == destination_account_id
      errors.add(:base, "Conta de origem e destino não podem ser a mesma")
    end
  end
end
