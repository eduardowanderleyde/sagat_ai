module Api
  module V1
    class BankAccountsController < ApplicationController
      include JwtAuthenticatable

      def show
        render json: current_user.bank_account
      end

      def create
        bank_account = current_user.build_bank_account(bank_account_params)
        if bank_account.save
          render json: bank_account, status: :created
        else
          render json: { errors: bank_account.errors.full_messages }, status: :unprocessable_entity
        end
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

        render json: transactions
      end

      private

      def bank_account_params
        params.require(:bank_account).permit(:account_number, :agency, :balance)
      end
    end
  end
end
