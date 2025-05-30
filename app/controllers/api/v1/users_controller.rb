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

      def index
        unless current_user&.admin?
          render json: { error: "Forbidden" }, status: :forbidden and return
        end
        users = User.all
        render json: users.as_json(except: :password_digest)
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password)
      end
    end
  end
end
