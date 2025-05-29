module Api
  module V1
    class ScheduledTransactionsController < ApplicationController
      def create
        scheduled_transaction = current_user.bank_account.scheduled_transactions.build(scheduled_transaction_params)
        scheduled_transaction.source_account = current_user.bank_account

        if scheduled_transaction.save
          ProcessScheduledTransactionWorker.perform_at(
            scheduled_transaction.scheduled_for,
            scheduled_transaction.id
          )
          
          render json: scheduled_transaction, status: :created
        else
          render json: { errors: scheduled_transaction.errors }, status: :unprocessable_entity
        end
      end

      private

      def scheduled_transaction_params
        params.require(:transaction).permit(
          :amount,
          :destination_account_id,
          :description,
          :scheduled_for
        )
      end
    end
  end
end 