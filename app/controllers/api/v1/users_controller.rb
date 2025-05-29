module Api
  module V1
    class UsersController < ApplicationController
      include JwtAuthenticatable

      def show
        render json: current_user.as_json(except: :password_digest)
      end

      def update
        if current_user.update(user_params)
          render json: current_user.as_json(except: :password_digest)
        else
          render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password)
      end
    end
  end
end
