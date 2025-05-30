module Api
  module V1
    class BankAccountsController < ApplicationController
      include JwtAuthenticatable

      def show
        render json: current_user.bank_account
      end

      def balance
        render json: { balance: current_user.bank_account.balance }
      end

      def statement
        transactions = current_user.bank_account.source_transactions
          .or(current_user.bank_account.destination_transactions)
          .order(created_at: :desc)

        transactions = transactions.where(created_at: params[:start_date]..params[:end_date]) if params[:start_date].present? && params[:end_date].present?
        transactions = transactions.where("amount >= ?", params[:min_amount]) if params[:min_amount].present?
        transactions = transactions.where(transaction_type: params[:type]) if params[:type].present?

        # Pagination
        transactions = transactions.page(params[:page]).per(params[:per_page] || 10)

        render json: {
          transactions: transactions,
          current_page: transactions.current_page,
          total_pages: transactions.total_pages,
          total_count: transactions.total_count
        }
      end
    end
  end
end
