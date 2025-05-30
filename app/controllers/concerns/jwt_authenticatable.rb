module JwtAuthenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request
    attr_reader :current_user
  end

  private

  def authenticate_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    begin
      decoded = TokenService.decode(token)
      @current_user = User.find(decoded["user_id"])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end

  def generate_token(user)
    JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base)
  end
end
# /
