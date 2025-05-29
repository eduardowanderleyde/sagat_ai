class ProcessScheduledTransactionWorker
  include Sidekiq::Worker

  def perform(scheduled_transaction_id)
    scheduled_transaction = ScheduledTransaction.find_by(id: scheduled_transaction_id)
    return unless scheduled_transaction && scheduled_transaction.status == "pending"

    source_account = scheduled_transaction.source_account
    destination_account = scheduled_transaction.destination_account

    # Check if there is still enough balance
    if source_account.balance < scheduled_transaction.amount
      scheduled_transaction.update(status: :failed, error_message: "Insufficient balance")
      return
    end

    # Create the transaction
    transaction = Transaction.create!(
      source_account: source_account,
      destination_account: destination_account,
      amount: scheduled_transaction.amount,
      transaction_type: "transfer",
      status: :pending,
      description: scheduled_transaction.description
    )

    # Update balances
    source_account.update_balance(-scheduled_transaction.amount)
    destination_account.update_balance(scheduled_transaction.amount)

    transaction.update(status: :completed)

    # Mark the scheduled transaction as processed
    scheduled_transaction.update!(status: :completed)
  rescue => e
    # Transaction has already been processed or no longer exists
    scheduled_transaction.update(status: :failed) if scheduled_transaction
  end
end
