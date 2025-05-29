module Api
  module V1
    class TransactionsController < ApplicationController
      include JwtAuthenticatable

      def create
        transaction = Transaction.new(transaction_params)
        transaction.source_account = current_user.bank_account
        transaction.transaction_type = "transfer"

        if transaction.save
          transaction.process!
          render json: transaction, status: :created
        else
          render json: { errors: transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def index
        transactions = current_user.bank_account.source_transactions
          .or(current_user.bank_account.destination_transactions)
          .order(created_at: :desc)

        transactions = transactions.where(created_at: params[:start_date]..params[:end_date]) if params[:start_date].present? && params[:end_date].present?
        transactions = transactions.where("amount >= ?", params[:min_amount]) if params[:min_amount].present?
        transactions = transactions.where(transaction_type: params[:type]) if params[:type].present?

        render json: transactions
      end

      def deposit
        account = current_user.bank_account
        transaction = Transaction.new(
          amount: params[:transaction][:amount],
          source_account: account,
          destination_account: account,
          description: params[:transaction][:description]
        )
        transaction.transaction_type = "deposit"

        if transaction.save
          transaction.process!
          render json: transaction, status: :created
        else
          render json: { errors: transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def transaction_params
        params.require(:transaction).permit(
          :amount,
          :destination_account_id,
          :description
        )
      end
    end
  end
end
