class TokenService
  def self.generate(user)
    JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base)
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
  rescue JWT::DecodeError
    nil
  end
end 