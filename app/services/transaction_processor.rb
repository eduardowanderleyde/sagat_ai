class TransactionProcessor
  def self.process(transaction)
    ActiveRecord::Base.transaction do
      transaction.source_account.update_balance(-transaction.amount) if transaction.transaction_type == "transfer"
      transaction.destination_account.update_balance(transaction.amount)
      transaction.update!(status: "completed")
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    transaction.update!(status: "failed")
    Rails.logger.error("Transaction failed: #{e.message}")
  end
end 