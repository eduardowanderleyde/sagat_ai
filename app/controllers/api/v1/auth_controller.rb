module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_request, only: [ :login, :register ]

      def login
        user = User.find_by(email: params[:email])
        if user.nil?
          render json: { error: "Email not found" }, status: :unauthorized
        elsif user.authenticate(params[:password])
          token = TokenService.generate(user)
          render json: { token: token, user: user.as_json(except: :password_digest) }
        else
          render json: { error: "Invalid password" }, status: :unauthorized
        end
      end

      def register
        user = User.new(user_params)
        if user.save
          user.create_bank_account(balance: 0)
          token = TokenService.generate(user)
          render json: { token: token, user: user.as_json(except: :password_digest) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :name, :cpf)
      end
    end
  end
end
